/**
 * Scratchpad Extension
 *
 * A per-session scratchpad directory for throwaway code experiments,
 * test projects (cargo new, npm init, ...), and temporary scripts,
 * so the working directory stays clean.
 *
 * - Scratchpad lives at ~/.pi/agent/scratchpad/<session-id>/
 * - Stale scratchpads from previous sessions are wiped on startup
 * - LLM gets a `scratchpad` tool (path / save / clear)
 * - /scratch command to inspect, save, clear, or open the scratchpad
 * - Contents are session-only, but can be copied to disk on demand
 */

import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import { execFileSync } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { StringEnum } from "@earendil-works/pi-ai";
import { Type } from "typebox";

const SCRATCH_ROOT = path.join(os.homedir(), ".pi", "agent", "scratchpad");

function copyDir(src: string, dest: string) {
	fs.mkdirSync(dest, { recursive: true });
	for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
		const s = path.join(src, entry.name);
		const d = path.join(dest, entry.name);
		if (entry.isDirectory()) copyDir(s, d);
		else if (entry.isFile()) fs.copyFileSync(s, d);
	}
}

export default function scratchpadExtension(pi: ExtensionAPI) {
	let scratchDir: string | undefined;

	function ensureDir(): string {
		if (!scratchDir) throw new Error("Scratchpad not initialized yet");
		fs.mkdirSync(scratchDir, { recursive: true });
		return scratchDir;
	}

	function clearDir(): void {
		const dir = ensureDir();
		for (const entry of fs.readdirSync(dir)) {
			fs.rmSync(path.join(dir, entry), { recursive: true, force: true });
		}
	}

	function saveDir(destination: string): string {
		const src = ensureDir();
		const dest = destination.startsWith("~")
			? path.join(os.homedir(), destination.slice(1))
			: path.resolve(destination);
		if (fs.existsSync(dest)) {
			throw new Error(`Destination already exists: ${dest}`);
		}
		copyDir(src, dest);
		return dest;
	}

	function summary(): string {
		const dir = ensureDir();
		const entries = fs.readdirSync(dir, { withFileTypes: true });
		if (entries.length === 0) return `${dir} (empty)`;
		const lines = entries
			.slice(0, 20)
			.map((e) => `${e.isDirectory() ? "d" : "-"} ${e.name}`);
		const more = entries.length > 20 ? `... and ${entries.length - 20} more` : "";
		return [dir, ...lines, more].filter(Boolean).join("\n");
	}

	// Per-session scratch dir; wipe stale scratchpads from other sessions
	pi.on("session_start", async (_event, ctx) => {
		const id =
			ctx.sessionManager.getSessionId() ??
			`ephemeral-${Date.now().toString(36)}`;
		scratchDir = path.join(SCRATCH_ROOT, id);
		fs.mkdirSync(scratchDir, { recursive: true });

		for (const entry of fs.readdirSync(SCRATCH_ROOT)) {
			if (entry !== id) {
				fs.rmSync(path.join(SCRATCH_ROOT, entry), {
					recursive: true,
					force: true,
				});
			}
		}
	});

	// Tell the LLM the scratchpad exists and when to use it
	pi.on("before_agent_start", async (event) => {
		if (!scratchDir) return;
		return {
			systemPrompt:
				event.systemPrompt +
				`\n\n## Scratchpad\n\n` +
				`A scratchpad directory is available at: ${scratchDir}\n` +
				`Use it for throwaway code experiments, test projects (e.g. cargo new, npm init), ` +
				`quick prototypes, and temporary or complicated scripts, instead of cluttering the ` +
				`current working directory. It is wiped between sessions. If the user wants to keep ` +
				`something, use the scratchpad tool with action "save" to copy it to a permanent location.`,
		};
	});

	// Tool for the LLM
	pi.registerTool({
		name: "scratchpad",
		label: "Scratchpad",
		description:
			"Interact with the session scratchpad directory: get its path, save its contents to a permanent location on disk, or clear it. " +
			"Use the scratchpad for code experiments, test projects (cargo new, etc.), and temporary scripts.",
		parameters: Type.Object({
			action: StringEnum(["path", "save", "clear"] as const, {
				description:
					"path: return the scratchpad directory path. save: copy contents to a permanent destination. clear: wipe the scratchpad.",
			}),
			destination: Type.Optional(
				Type.String({
					description:
						"Required for save: absolute or ~ path to copy the scratchpad contents into. Must not already exist.",
				}),
			),
		}),
		async execute(_toolCallId, params) {
			try {
				switch (params.action) {
					case "path":
						return {
							content: [{ type: "text", text: ensureDir() }],
							details: {},
						};
					case "save": {
						const dest =
							params.destination ??
							path.join(
								os.homedir(),
								`scratchpad-${new Date().toISOString().replace(/[:.]/g, "-")}`,
							);
						const saved = saveDir(dest);
						return {
							content: [
								{ type: "text", text: `Scratchpad saved to ${saved}` },
							],
							details: {},
						};
					}
					case "clear":
						clearDir();
						return {
							content: [{ type: "text", text: "Scratchpad cleared." }],
							details: {},
						};
				}
			} catch (err) {
				return {
					content: [
						{
							type: "text",
							text: `Error: ${err instanceof Error ? err.message : String(err)}`,
						},
					],
					details: {},
					isError: true,
				};
			}
		},
	});

	// Command for the user: /scratch [save <dest> | clear | open]
	pi.registerCommand("scratch", {
		description:
			"Manage the scratchpad: /scratch (show contents), /scratch save <dest>, /scratch clear, /scratch open",
		handler: async (args, ctx) => {
			const [sub, ...rest] = args.trim().split(/\s+/).filter(Boolean);
			try {
				switch (sub) {
					case undefined:
					case "":
						ctx.ui.notify(summary(), "info");
						break;
					case "save": {
						const dest =
							rest.join(" ") ||
							path.join(
								os.homedir(),
								`scratchpad-${new Date().toISOString().replace(/[:.]/g, "-")}`,
							);
						ctx.ui.notify(`Scratchpad saved to ${saveDir(dest)}`, "info");
						break;
					}
					case "clear": {
						if (ctx.hasUI) {
							const ok = await ctx.ui.confirm(
								"Clear scratchpad?",
								"This wipes everything in the session scratchpad.",
							);
							if (!ok) return;
						}
						clearDir();
						ctx.ui.notify("Scratchpad cleared.", "info");
						break;
					}
					case "open":
						execFileSync("open", [ensureDir()]);
						break;
					default:
						ctx.ui.notify(
							"Usage: /scratch [save <dest> | clear | open]",
							"warning",
						);
				}
			} catch (err) {
				ctx.ui.notify(
					`Scratchpad error: ${err instanceof Error ? err.message : String(err)}`,
					"error",
				);
			}
		},
	});
}
