# Graph Diagnostics

Graph diagnostics are a temporary analysis and health-check layer. They are not an authoritative knowledge source and should not become a third official knowledge base.

| Layer | Role | Audience | Content |
| --- | --- | --- | --- |
| Human knowledge base | Official people-readable knowledge | Employees, managers | SOPs, policies, training, publishable docs |
| Agent knowledge base | Durable Agent-readable knowledge | Agents, maintainers | Task manuals, retrieval maps, rule indexes, experience candidates |
| Graph diagnostics | Automatically extracted relationship map | Agents, maintainers | Code/doc relationships, bridge nodes, conflict candidates, gaps |

## Use Cases

- Find rule conflicts.
- Find isolated Agent knowledge pages.
- Detect template/live-rule confusion.
- Surface common-error candidates.
- Discover unclear module or file relationships.
- Identify missing links between rules, templates, and knowledge pages.

## Boundaries

- Do not automatically write graph findings into root `AGENTS.md`, official rules, human knowledge, Agent knowledge, or company facts.
- Graph findings must be checked against source files before becoming candidates.
- If graph export creates Markdown, keep it under a separate graph output directory unless a maintainer deliberately promotes a reviewed summary.
- Do not import the entire graph export into the main Agent knowledge vault.

## Promotion Flow

1. Run graph diagnostics.
2. Inspect source nodes and evidence.
3. If useful but unconfirmed, record a candidate in the Agent knowledge workbench.
4. If it changes runtime behavior, update the relevant rule files and governance checks.
5. If employees need to read it, convert it into a human-readable document before human-KB publication.
