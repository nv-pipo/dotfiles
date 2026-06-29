/**
 * @token-counter - Token usage tracker footer extension
 *
 * Tracks accumulated input/output tokens and cost across turns.
 * Shows real-time stats in the footer after each LLM turn.
 *
 * Usage: pi automatically loads from ~/.pi/agent/extensions/
 * Toggle via /token-counter
 */

import type { AssistantMessage, Model, ThinkingLevel } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

export default function (pi: ExtensionAPI) {
	let enabled = true;

	// Accumulated totals across the session
	let totalInput = 0;
	let totalOutput = 0;
	let totalCost = 0;
	let turnCount = 0;

	// Per-last-turn stats (for the delta display)
	let lastInput = 0;
	let lastOutput = 0;

	// Previous totals for delta computation (when scanning branch)
	let prevTotalInput = 0;
	let prevTotalOutput = 0;

	// Current provider / model info
	let currentProvider = "";
	let currentModelId = "";

	// Current thinking level
	let currentThinkingLevel: ThinkingLevel = "medium";

	function computeTotals(ctx: { sessionManager: { getBranch: () => unknown[] } }) {
		let input = 0,
			output = 0,
			cost = 0;
		let turns = 0;
		for (const e of ctx.sessionManager.getBranch()) {
			if (e.type === "message" && e.message.role === "assistant") {
				const m = e.message as AssistantMessage;
				if (m.usage) {
					input += m.usage.input ?? 0;
					output += m.usage.output ?? 0;
					cost += m.usage.cost?.total ?? 0;
				}
				turns++;
			}
		}
		return { input, output, cost, turns };
	}

	function refreshTotals(ctx: {
		sessionManager: { getBranch: () => unknown[] };
	}) {
		const stats = computeTotals(ctx);
		// Calculate delta from last turn
		if (turnCount > 0 && stats.turns > turnCount) {
			lastInput = stats.input - prevTotalInput;
			lastOutput = stats.output - prevTotalOutput;
		}
		prevTotalInput = stats.input;
		prevTotalOutput = stats.output;
		totalInput = stats.input;
		totalOutput = stats.output;
		totalCost = stats.cost;
		turnCount = stats.turns;
	}

	function fmt(n: number): string {
		if (n < 1000) return `${n}`;
		if (n < 1_000_000) return `${(n / 1000).toFixed(1)}k`;
		return `${(n / 1_000_000).toFixed(1)}m`;
	}

	function fmtLevel(level: ThinkingLevel): string {
		const map: Record<ThinkingLevel, string> = {
			minimal: "min",
			low: "low",
			medium: "med",
			high: "high",
			xhigh: "xhi",
		};
		return map[level];
	}

	function fmtCost(n: number): string {
		if (n < 0.0001) return "$0";
		if (n < 0.01) return `$${n.toFixed(4)}`;
		if (n < 1) return `$${n.toFixed(3)}`;
		return `$${n.toFixed(2)}`;
	}

	function updateModel(model: Model<any> | undefined) {
		if (model) {
			currentProvider = model.provider;
			currentModelId = model.id;
		} else {
			currentProvider = "";
			currentModelId = "";
		}
	}

	pi.on("model_select", (event) => {
		updateModel(event.model);
	});

	pi.on("thinking_level_select", (event) => {
		currentThinkingLevel = event.level;
	});

	pi.on("session_start", async (_event, ctx) => {
		totalInput = 0;
		totalOutput = 0;
		totalCost = 0;
		turnCount = 0;
		lastInput = 0;
		lastOutput = 0;
		prevTotalInput = 0;
		prevTotalOutput = 0;

		updateModel(ctx.model);
		currentThinkingLevel = pi.getThinkingLevel();
		refreshTotals(ctx);

		if (enabled) {
			setupFooter(ctx);
		}
	});

	pi.on("turn_end", async (event, ctx) => {
		if (!enabled) return;

		// Use the event message's usage data directly for efficiency
		if (event.message?.usage) {
			const u = event.message.usage as {
				input?: number;
				output?: number;
				cost?: { total?: number };
			};
			lastInput = u.input ?? 0;
			lastOutput = u.output ?? 0;
			totalInput += lastInput;
			totalOutput += lastOutput;
			totalCost += u.cost?.total ?? 0;
			turnCount++;
		} else {
			// Fallback: scan the branch
			refreshTotals(ctx);
		}
	});

	function setupFooter(ctx: {
		ui: {
			setFooter: (
				fn:
					| ((
							tui: { requestRender: () => void },
							theme: {
								fg: (color: string, text: string) => string;
								bold: (text: string) => string;
							},
							footerData: {
								getGitBranch: () => string | null;
								getExtensionStatuses: () => ReadonlyMap<string, string>;
								onBranchChange: (fn: () => void) => () => void;
							},
					  ) => {
							render: (width: number) => string[];
							invalidate: () => void;
							dispose?: () => void;
					  })
					| undefined,
			) => void;
			theme: {
				fg: (color: string, text: string) => string;
				bold: (text: string) => string;
			};
		};
		model?: Model<any> | undefined;
	}) {
		const theme = ctx.ui.theme;

		ctx.ui.setFooter((tui, _theme, footerData) => {
			const unsub = footerData.onBranchChange(() => tui.requestRender());

			return {
				dispose: unsub,
				invalidate() {},
				render(width: number): string[] {
					const dim = (s: string) => theme.fg("dim", s);
					const accent = (s: string) => theme.fg("accent", s);
					const success = (s: string) => theme.fg("success", s);
					const warn = (s: string) => theme.fg("warning", s);

					// Token parts
					const turnStr = turnCount > 0 ? accent(`#${turnCount}`) : dim("-");

					// Input tokens
					const inputStr = totalInput > 0 ? fmt(totalInput) : "0";
					// Output tokens
					const outputStr = totalOutput > 0 ? fmt(totalOutput) : "0";

					// Per-turn delta
					let deltaStr = "";
					if (lastInput > 0 || lastOutput > 0) {
						const parts: string[] = [];
						if (lastInput > 0) parts.push(`↑${fmt(lastInput)}`);
						if (lastOutput > 0) parts.push(`↓${fmt(lastOutput)}`);
						deltaStr = dim(` (${parts.join(" ")})`);
					}

					// Cost
					const costStr = totalCost > 0 ? fmtCost(totalCost) : "$0";

					// Left part: token stats
					const left = `${accent("⊡")} ${dim("in:")}${success(inputStr)} ${dim("out:")}${success(outputStr)}${deltaStr} ${dim("cost:")}${warn(costStr)}`;

					// Thinking level
					const levelStr = dim(fmtLevel(currentThinkingLevel));

					// Right part: provider/model + thinking level + turn
					const modelStr =
						currentProvider && currentModelId
							? `${accent(currentProvider)} ${currentModelId}`
							: "";
					const right = modelStr
						? `${modelStr} ${levelStr}  ${dim("turn")} ${turnStr}`
						: `${levelStr}  ${dim("turn")} ${turnStr}`;

					const pad = " ".repeat(
						Math.max(1, width - visibleWidth(left) - visibleWidth(right)),
					);
					return [truncateToWidth(left + pad + right, width)];
				},
			};
		});
	}

	pi.registerCommand("token-counter", {
		description: "Toggle token usage footer display",
		handler: async (_args, ctx) => {
			enabled = !enabled;

			if (enabled) {
				refreshTotals(ctx);
				setupFooter(ctx);
				ctx.ui.notify("Token counter enabled", "info");
			} else {
				ctx.ui.setFooter(undefined);
				ctx.ui.notify("Token counter disabled", "info");
			}
		},
	});
}