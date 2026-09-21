import type { ExtensionAPI, ExtensionCommandContext } from "@earendil-works/pi-coding-agent";
import * as fs from "node:fs";
import * as path from "node:path";
import * as os from "node:os";

// On-demand skills live here. This directory is NOT scanned by pi itself,
// so these skills cost zero context until toggled on with /load.
const DORMANT_DIR = path.join(os.homedir(), ".pi", "agent", "skills-on-demand");

interface DormantSkill {
	name: string;
	description: string;
	file: string;
}

function parseFrontmatter(text: string): Record<string, string> {
	const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---/);
	if (!match) return {};
	const out: Record<string, string> = {};
	for (const line of match[1].split(/\r?\n/)) {
		const kv = line.match(/^(\w[\w-]*):\s*(.*)$/);
		if (kv) out[kv[1]] = kv[2].trim();
	}
	return out;
}

function stripFrontmatter(text: string): string {
	return text.replace(/^---\r?\n[\s\S]*?\r?\n---\r?\n?/, "");
}

function scanSkills(): DormantSkill[] {
	const skills: DormantSkill[] = [];
	let entries: fs.Dirent[];
	try {
		entries = fs.readdirSync(DORMANT_DIR, { withFileTypes: true });
	} catch {
		return skills;
	}
	for (const entry of entries) {
		let file: string | null = null;
		if (entry.isDirectory()) {
			const candidate = path.join(DORMANT_DIR, entry.name, "SKILL.md");
			if (fs.existsSync(candidate)) file = candidate;
		} else if (entry.isFile() && entry.name.endsWith(".md")) {
			file = path.join(DORMANT_DIR, entry.name);
		}
		if (!file) continue;
		try {
			const text = fs.readFileSync(file, "utf8");
			const fm = parseFrontmatter(text);
			if (fm.name && fm.description) {
				skills.push({ name: fm.name, description: fm.description, file });
			}
		} catch {
			// skip unreadable files
		}
	}
	return skills.sort((a, b) => a.name.localeCompare(b.name));
}

export default function (pi: ExtensionAPI) {
	// Session-specific state: enabled skills live only in memory.
	const enabled = new Map<string, DormantSkill>();

	function updateStatus(ctx: { ui: { setStatus: (k: string, v: string | undefined) => void } }) {
		if (enabled.size === 0) {
			ctx.ui.setStatus("on-demand-skills", undefined);
		} else {
			ctx.ui.setStatus("on-demand-skills", `skills: ${[...enabled.keys()].join(", ")}`);
		}
	}

	function setEnabled(names: Set<string>, all: DormantSkill[], ctx: ExtensionCommandContext) {
		enabled.clear();
		for (const skill of all) {
			if (names.has(skill.name)) enabled.set(skill.name, skill);
		}
		updateStatus(ctx);
	}

	async function showPicker(ctx: ExtensionCommandContext) {
		const skills = scanSkills();
		if (skills.length === 0) {
			ctx.ui.notify(`No on-demand skills found in ${DORMANT_DIR}`, "warning");
			return;
		}

		const result = await ctx.ui.custom<Set<string> | null>(
			(tui, theme, _kb, done) => {
				let index = 0;
				const checked = new Set<string>(enabled.keys());

				return {
					render(width: number) {
						const lines: string[] = [];
						lines.push(theme.fg("accent", " On-demand skills ") + theme.fg("dim", " (space: toggle, enter: apply, esc: cancel)"));
						lines.push("");
						for (let i = 0; i < skills.length; i++) {
							const s = skills[i];
							const cursor = i === index ? theme.fg("accent", ">") : " ";
							const box = checked.has(s.name) ? theme.fg("success", "[x]") : theme.fg("dim", "[ ]");
							const name = theme.fg(i === index ? "accent" : "text", ` ${s.name}`);
							const maxDesc = Math.max(10, width - s.name.length - 10);
							const desc =
								s.description.length > maxDesc ? s.description.slice(0, maxDesc - 1) + "..." : s.description;
							lines.push(`${cursor} ${box}${name} ${theme.fg("dim", "- " + desc)}`);
						}
						return lines;
					},
					handleInput(data: string) {
						if (data === "\x1b[A" || data === "k") {
							index = Math.max(0, index - 1);
						} else if (data === "\x1b[B" || data === "j") {
							index = Math.min(skills.length - 1, index + 1);
						} else if (data === " ") {
							const name = skills[index].name;
							if (checked.has(name)) checked.delete(name);
							else checked.add(name);
						} else if (data === "\r") {
							done(new Set(checked));
							return;
						} else if (data === "\x1b") {
							done(null);
							return;
						}
						tui.requestRender();
					},
				};
			},
			{ overlay: true },
		);

		if (result !== null) {
			setEnabled(result, skills, ctx);
			const names = [...enabled.keys()];
			ctx.ui.notify(
				names.length > 0 ? `Loaded skills: ${names.join(", ")}` : "All on-demand skills unloaded",
				"info",
			);
		}
	}

	pi.registerCommand("load", {
		description: "Toggle on-demand skills for this session (only loaded skills cost context)",
		handler: async (args, ctx) => {
			const skills = scanSkills();
			const trimmed = args.trim();

			if (trimmed === "" && ctx.hasUI && ctx.mode === "tui") {
				await showPicker(ctx);
				return;
			}

			if (trimmed === "" || trimmed === "list") {
				const lines = skills.map(
					(s) => `${enabled.has(s.name) ? "[x]" : "[ ]"} ${s.name} - ${s.description}`,
				);
				ctx.ui.notify(
					lines.length > 0 ? lines.join("\n") : `No on-demand skills found in ${DORMANT_DIR}`,
					"info",
				);
				return;
			}

			if (trimmed === "none") {
				enabled.clear();
				updateStatus(ctx);
				ctx.ui.notify("All on-demand skills unloaded", "info");
				return;
			}

			const skill = skills.find((s) => s.name === trimmed);
			if (!skill) {
				ctx.ui.notify(
					`Unknown skill "${trimmed}". Available: ${skills.map((s) => s.name).join(", ") || "(none)"}`,
					"warning",
				);
				return;
			}
			if (enabled.has(skill.name)) {
				enabled.delete(skill.name);
				ctx.ui.notify(`Unloaded skill: ${skill.name}`, "info");
			} else {
				enabled.set(skill.name, skill);
				ctx.ui.notify(`Loaded skill: ${skill.name}`, "info");
			}
			updateStatus(ctx);
		},
	});

	// Inject enabled skills into the system prompt each turn.
	// Toggling a skill off removes it from all future turns.
	pi.on("before_agent_start", async (event) => {
		if (enabled.size === 0) return;
		let addendum = "\n\n# On-demand skills (loaded by user via /load)\n";
		for (const skill of enabled.values()) {
			try {
				const body = stripFrontmatter(fs.readFileSync(skill.file, "utf8")).trim();
				addendum += `\n## Skill: ${skill.name}\nSkill file: ${skill.file}\n\n${body}\n`;
			} catch {
				// skip unreadable skill
			}
		}
		return { systemPrompt: event.systemPrompt + addendum };
	});

	pi.on("session_start", async (_event, ctx) => {
		enabled.clear();
		updateStatus(ctx);
	});
}
