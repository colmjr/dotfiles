/**
 * Discuss Mode Extension
 *
 * A mentoring/discussion mode for learning by doing.
 * When enabled, the agent cannot write or edit code — it can only
 * read, research, and discuss. You write the code; pi guides.
 *
 * Features:
 * - /discuss command or Ctrl+Alt+D to toggle
 * - Built-in edit/write tools disabled while active
 * - Bash restricted to read-only commands (plus cargo check/test/clippy for reviewing your work)
 * - Injects a Socratic Rust-mentor system prompt
 * - State persists across session resume
 */

import type { AgentMessage } from "@earendil-works/pi-agent-core";
import type { TextContent } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Key } from "@earendil-works/pi-tui";

const DISCUSS_MODE_TOOLS = ["read", "bash", "grep", "find", "ls", "questionnaire"];
const NORMAL_MODE_TOOLS = ["read", "bash", "edit", "write"];
const DISCUSS_MODE_DISABLED_TOOLS = new Set<string>(["edit", "write"]);
const DISCUSS_MANAGED_TOOLS = new Set<string>([...DISCUSS_MODE_TOOLS, ...NORMAL_MODE_TOOLS]);

interface DiscussModeState {
	enabled: boolean;
	toolsBeforeDiscussMode?: string[];
}

// Destructive / code-writing commands blocked in discuss mode
const DESTRUCTIVE_PATTERNS = [
	/\brm\b/i,
	/\brmdir\b/i,
	/\bmv\b/i,
	/\bcp\b/i,
	/\bmkdir\b/i,
	/\btouch\b/i,
	/\bchmod\b/i,
	/\bchown\b/i,
	/\bln\b/i,
	/\btee\b/i,
	/\btruncate\b/i,
	/\bdd\b/i,
	/(^|[^<])>(?!>)/,
	/>>/,
	/\bsudo\b/i,
	/\bgit\s+(add|commit|push|pull|merge|rebase|reset|checkout|stash|cherry-pick|revert|apply|format-patch)/i,
	/\b(vim?|nvim|nano|emacs|code|subl|helix|hx)\b/i,
	/\b(patch|ed|ex)\b/i,
];

// Read-only commands allowed in discuss mode.
// cargo check/test/clippy/build are allowed so the agent can verify and
// discuss YOUR code — they never modify your sources.
const SAFE_PATTERNS = [
	/^\s*cat\b/,
	/^\s*head\b/,
	/^\s*tail\b/,
	/^\s*grep\b/,
	/^\s*rg\b/,
	/^\s*find\b/,
	/^\s*fd\b/,
	/^\s*ls\b/,
	/^\s*eza\b/,
	/^\s*bat\b/,
	/^\s*tree\b/,
	/^\s*pwd\b/,
	/^\s*echo\b/,
	/^\s*printf\b/,
	/^\s*wc\b/,
	/^\s*sort\b/,
	/^\s*uniq\b/,
	/^\s*diff\b/,
	/^\s*file\b/,
	/^\s*stat\b/,
	/^\s*which\b/,
	/^\s*type\b/,
	/^\s*env\b/,
	/^\s*printenv\b/,
	/^\s*uname\b/,
	/^\s*date\b/,
	/^\s*ps\b/,
	/^\s*jq\b/,
	/^\s*sed\s+-n/i,
	/^\s*awk\b/,
	/^\s*curl\s/i,
	/^\s*git\s+(status|log|diff|show|branch|remote|blame|ls-|config\s+--get)/i,
	/^\s*cargo\s+(check|clippy|test|build|doc\s+--open|tree|metadata|fmt\s+--check|search|explain)/i,
	/^\s*rustc\s+(--version|--explain|--print)/i,
	/^\s*rustup\s+(show|component\s+list|target\s+list)/i,
	/^\s*iwctl\b/i,
	/^\s*iw\s+(dev|link|list)/i,
];

function isSafeCommand(command: string): boolean {
	const isDestructive = DESTRUCTIVE_PATTERNS.some((p) => p.test(command));
	const isSafe = SAFE_PATTERNS.some((p) => p.test(command));
	return !isDestructive && isSafe;
}

export default function discussModeExtension(pi: ExtensionAPI): void {
	let discussModeEnabled = false;
	let toolsBeforeDiscussMode: string[] | undefined;

	pi.registerFlag("discuss", {
		description: "Start in discuss mode (no code writing, mentoring only)",
		type: "boolean",
		default: false,
	});

	function updateStatus(ctx: ExtensionContext): void {
		if (discussModeEnabled) {
			ctx.ui.setStatus("discuss-mode", ctx.ui.theme.fg("accent", "discuss"));
		} else {
			ctx.ui.setStatus("discuss-mode", undefined);
		}
	}

	function uniqueToolNames(toolNames: string[]): string[] {
		return [...new Set(toolNames)];
	}

	function getDiscussModeTools(activeToolNames: string[]): string[] {
		return uniqueToolNames([
			...activeToolNames.filter((name) => !DISCUSS_MODE_DISABLED_TOOLS.has(name)),
			...DISCUSS_MODE_TOOLS,
		]);
	}

	function getNormalModeTools(activeToolNames: string[]): string[] {
		return uniqueToolNames([
			...NORMAL_MODE_TOOLS,
			...activeToolNames.filter((name) => !DISCUSS_MANAGED_TOOLS.has(name)),
		]);
	}

	function enableDiscussModeTools(): void {
		if (toolsBeforeDiscussMode === undefined) {
			toolsBeforeDiscussMode = pi.getActiveTools();
		}
		pi.setActiveTools(getDiscussModeTools(toolsBeforeDiscussMode));
	}

	function restoreNormalModeTools(): void {
		pi.setActiveTools(toolsBeforeDiscussMode ?? getNormalModeTools(pi.getActiveTools()));
		toolsBeforeDiscussMode = undefined;
	}

	function persistState(): void {
		pi.appendEntry("discuss-mode", {
			enabled: discussModeEnabled,
			toolsBeforeDiscussMode,
		});
	}

	function toggleDiscussMode(ctx: ExtensionContext): void {
		discussModeEnabled = !discussModeEnabled;

		if (discussModeEnabled) {
			enableDiscussModeTools();
			ctx.ui.notify("Discuss mode enabled. Write/edit tools disabled — you drive, I guide.");
		} else {
			restoreNormalModeTools();
			ctx.ui.notify("Discuss mode disabled. Full access restored.");
		}
		updateStatus(ctx);
		persistState();
	}

	pi.registerCommand("discuss", {
		description: "Toggle discuss mode (mentoring only, no code writing)",
		handler: async (_args, ctx) => toggleDiscussMode(ctx),
	});

	pi.registerShortcut(Key.ctrlAlt("d"), {
		description: "Toggle discuss mode",
		handler: async (ctx) => toggleDiscussMode(ctx),
	});

	// Block code-writing / destructive bash commands in discuss mode
	pi.on("tool_call", async (event) => {
		if (!discussModeEnabled || event.toolName !== "bash") return;

		const command = event.input.command as string;
		if (!isSafeCommand(command)) {
			return {
				block: true,
				reason: `Discuss mode: command blocked (not read-only). Use /discuss to disable discuss mode first.\nCommand: ${command}`,
			};
		}
	});

	// Filter out stale discuss mode context when not in discuss mode
	pi.on("context", async (event) => {
		if (discussModeEnabled) return;

		return {
			messages: event.messages.filter((m) => {
				const msg = m as AgentMessage & { customType?: string };
				if (msg.customType === "discuss-mode-context") return false;
				if (msg.role !== "user") return true;

				const content = msg.content;
				if (typeof content === "string") {
					return !content.includes("[DISCUSS MODE ACTIVE]");
				}
				if (Array.isArray(content)) {
					return !content.some(
						(c) => c.type === "text" && (c as TextContent).text?.includes("[DISCUSS MODE ACTIVE]"),
					);
				}
				return true;
			}),
		};
	});

	// Inject the mentoring system prompt before the agent starts
	pi.on("before_agent_start", async () => {
		if (!discussModeEnabled) return;

		return {
			message: {
				customType: "discuss-mode-context",
				content: `[DISCUSS MODE ACTIVE]
You are in discuss mode - a mentoring session. The user is learning Rust (coming from C/C++)
and contributes to impala, a TUI for the iwd wireless daemon. They want to practice and
learn by writing the code THEMSELVES.

Hard rules:
- NEVER write implementation code. No full functions, no patches, no copy-pasteable solutions.
- Your edit/write tools are disabled, and bash is restricted to read-only commands anyway.
- You may read their code (read/grep/find/ls) and run cargo check/clippy/test to review THEIR work.
- Tiny illustrative snippets (2-3 lines max) are allowed only to explain a concept, never as a solution to their task.

How to mentor:
- Be Socratic: guide with questions that lead them to the answer rather than stating it.
- Explain the "why": ownership, lifetimes, borrowing, error handling, trait design, API ergonomics —
  connect Rust concepts to what they already know from C/C++ when helpful.
- When they share code or an error, review it: point out what is good, ask what they think is wrong,
  and nudge them toward the fix. Let THEM type the fix.
- Discuss design trade-offs (e.g. for impala: ratatui architecture, state management, async vs blocking
  D-Bus/iwd calls, widget structure) rather than dictating one answer.
- If they ask you to "just write it", refuse kindly and instead break the problem into small
  steps they can implement one at a time.
- Suggest resources (the Rust Book, rustlings, docs.rs pages) when a concept needs deeper study.

Tone: encouraging, curious, and concise. This is a conversation, not a code generator.`,
				display: false,
			},
		};
	});

	// Restore state on session start/resume
	pi.on("session_start", async (_event, ctx) => {
		if (pi.getFlag("discuss") === true) {
			discussModeEnabled = true;
		}

		const entries = ctx.sessionManager.getEntries();
		const discussEntry = entries
			.filter((e: { type: string; customType?: string }) => e.type === "custom" && e.customType === "discuss-mode")
			.pop() as { data?: DiscussModeState } | undefined;

		if (discussEntry?.data) {
			discussModeEnabled = discussEntry.data.enabled ?? discussModeEnabled;
			toolsBeforeDiscussMode = discussEntry.data.toolsBeforeDiscussMode ?? toolsBeforeDiscussMode;
		}

		if (discussModeEnabled) {
			enableDiscussModeTools();
		}
		updateStatus(ctx);
	});
}
