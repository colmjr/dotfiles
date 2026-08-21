/**
 * Compaction Memory Extension
 *
 * Two things happen around compaction:
 *
 * 1. After compaction, the LLM only sees the summary and recent messages.
 *    This extension appends a notice to the compaction summary message
 *    (via the `context` event, non-destructively) telling the agent that
 *    compaction happened and that the full transcript is still searchable.
 *
 * 2. A `search_history` tool lets the agent search the full session
 *    transcript, including messages that were compacted away, to recover
 *    exact details (code, file contents, tool outputs, decisions).
 *
 * Usage:
 *   Place in ~/.pi/agent/extensions/ and run /reload
 */

import type { ExtensionAPI, SessionEntry } from "@earendil-works/pi-coding-agent";
import { getLatestCompactionEntry } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

// Matches COMPACTION_SUMMARY_PREFIX in pi's core/messages (not exported from the package index)
const COMPACTION_PREFIX = "The conversation history before this point was compacted into the following summary:";

const NOTICE_MARKER = "[compaction-notice]";
const NOTICE = `

${NOTICE_MARKER} The conversation before this summary was compacted to free up context. The full original transcript (messages, tool calls, and tool outputs) is still stored in this session but is no longer in your context. If you need exact details that were compacted away, such as earlier code, file contents, commands, or decisions, use the search_history tool to search the pre-compaction transcript.`;

/** Extract searchable plain text from a session entry. Returns null for entries with no text. */
function entryToText(entry: SessionEntry): { label: string; text: string } | null {
	switch (entry.type) {
		case "message": {
			const msg = entry.message as {
				role: string;
				content?: unknown;
				command?: string;
				output?: string;
				summary?: string;
				toolName?: string;
			};

			if (msg.role === "bashExecution") {
				const text = [`$ ${msg.command ?? ""}`, msg.output ?? ""].join("\n").trim();
				return text ? { label: "bash", text } : null;
			}

			if (msg.role === "compactionSummary" || msg.role === "branchSummary") {
				return { label: msg.role, text: msg.summary ?? "" };
			}

			const parts: string[] = [];
			if (typeof msg.content === "string") {
				parts.push(msg.content);
			} else if (Array.isArray(msg.content)) {
				for (const c of msg.content as Array<Record<string, unknown>>) {
					if (c.type === "text" && typeof c.text === "string") {
						parts.push(c.text);
					} else if (c.type === "toolCall") {
						parts.push(`[tool call] ${String(c.name)}(${JSON.stringify(c.arguments)})`);
					} else if (c.type === "thinking" && typeof c.thinking === "string") {
						parts.push(`[thinking] ${c.thinking}`);
					}
				}
			}
			const label = msg.role === "toolResult" ? `toolResult(${msg.toolName ?? "?"})` : msg.role;
			const text = parts.join("\n").trim();
			return text ? { label, text } : null;
		}

		case "compaction":
			return { label: "compaction", text: entry.summary };
		case "branch_summary":
			return { label: "branch_summary", text: entry.summary };
		case "custom_message": {
			const content = entry.content;
			const text =
				typeof content === "string"
					? content
					: Array.isArray(content)
						? content
								.filter((c): c is { type: "text"; text: string } => c.type === "text")
								.map((c) => c.text)
								.join("\n")
						: "";
			return text.trim() ? { label: `custom(${entry.customType})`, text } : null;
		}

		default:
			return null;
	}
}

export default function (pi: ExtensionAPI) {
	// 1. Attach the notice to the compaction summary on every LLM call.
	// The `context` event provides a deep copy, so this never mutates the session.
	pi.on("context", async (event) => {
		let touched = false;
		for (const msg of event.messages) {
			if (msg.role !== "user" || !Array.isArray(msg.content)) continue;
			for (const part of msg.content) {
				if (
					part.type === "text" &&
					part.text.startsWith(COMPACTION_PREFIX) &&
					!part.text.includes(NOTICE_MARKER)
				) {
					part.text += NOTICE;
					touched = true;
				}
			}
		}
		return touched ? { messages: event.messages } : undefined;
	});

	// 2. Tool to search the full transcript, including compacted-away messages.
	pi.registerTool({
		name: "search_history",
		label: "Search History",
		description:
			"Search the full session transcript, including messages that were compacted away and are no longer in your context. " +
			"Use this after compaction to recover exact details such as earlier file contents, code, commands, tool outputs, or decisions. " +
			"Performs a case-insensitive substring search and returns matching snippets with their position in the session.",
		promptSnippet: "Search the full session transcript, including compacted-away messages",
		promptGuidelines: [
			"Use search_history when you need details from earlier in the session that may have been compacted away, instead of guessing or re-running commands.",
		],
		parameters: Type.Object({
			query: Type.String({ description: "Text to search for (case-insensitive substring match)" }),
			maxResults: Type.Optional(
				Type.Number({ description: "Maximum number of matching snippets to return (default 10)" }),
			),
			contextChars: Type.Optional(
				Type.Number({ description: "Characters of surrounding context per match (default 200)" }),
			),
		}),

		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			const query = params.query;
			if (!query.trim()) {
				throw new Error("query must not be empty");
			}
			const maxResults = Math.max(1, Math.floor(params.maxResults ?? 10));
			const contextChars = Math.max(0, Math.floor(params.contextChars ?? 200));

			const entries = ctx.sessionManager.getBranch();

			// Determine which entries are outside the current LLM context:
			// everything before the latest compaction's firstKeptEntryId.
			const latestCompaction = getLatestCompactionEntry(entries);
			let boundaryIndex = -1;
			if (latestCompaction) {
				boundaryIndex = entries.findIndex((e) => e.id === latestCompaction.firstKeptEntryId);
			}

			const needle = query.toLowerCase();

			// Extract searchable text for all entries once
			const extracted = entries.map((e) => entryToText(e));

			// Pass 1: count total matches
			let totalMatches = 0;
			for (const ex of extracted) {
				if (!ex) continue;
				const haystack = ex.text.toLowerCase();
				let at = haystack.indexOf(needle);
				while (at !== -1) {
					totalMatches++;
					at = haystack.indexOf(needle, at + needle.length);
				}
			}

			// Pass 2: collect up to maxResults snippets
			const snippets: string[] = [];
			outer: for (let i = 0; i < entries.length; i++) {
				const ex = extracted[i];
				if (!ex) continue;

				const haystack = ex.text.toLowerCase();
				let pos = 0;
				while (true) {
					const at = haystack.indexOf(needle, pos);
					if (at === -1) break;

					const start = Math.max(0, at - contextChars);
					const end = Math.min(ex.text.length, at + query.length + contextChars);
					const snippet =
						(start > 0 ? "..." : "") + ex.text.slice(start, end) + (end < ex.text.length ? "..." : "");

					const where = boundaryIndex >= 0 && i < boundaryIndex ? "compacted away" : "in current context";
					snippets.push(`--- entry #${i} | ${ex.label} | ${where} ---\n${snippet}`);
					if (snippets.length >= maxResults) break outer;

					pos = at + needle.length;
				}
			}

			if (snippets.length === 0) {
				return {
					content: [{ type: "text", text: `No matches for "${query}" in the session transcript.` }],
					details: { matches: 0 },
				};
			}

			const header = `Found ${totalMatches} match(es) for "${query}" (showing ${snippets.length}):\n`;
			return {
				content: [{ type: "text", text: header + "\n" + snippets.join("\n\n") }],
				details: { matches: totalMatches, shown: snippets.length },
			};
		},
	});
}
