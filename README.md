# BEANS

**Beginning to End Architectural Navigation System**

This repository is the runnable BEANS seed-evolution experiment.

**Primary engine:** [`ShengranHu/ADAS`](https://github.com/ShengranHu/ADAS), pinned to upstream commit `2702bee8fefda42255efc5be9f60e3bd3db96ae4`.

BEANS uses ADAS Meta Agent Search to generate, mutate, reflect on, evaluate, and archive BEANS seed candidates. The experiment optimizes the seed itself—not another surrounding platform.

## One-click local run (Windows)

**Prerequisite:** Docker Desktop.

Double-click:

```text
RUN_BEANS.cmd
```

If no API key is already present, the launcher asks for one in a hidden prompt. The key is passed only to the running container, is not written to the repository or an env file, and the PowerShell process clears its local variable after Docker exits.

Results appear in `results/`.

## One-click GitHub run

If the repository has an Actions secret named `OPENAI_API_KEY`:

**Actions → Run BEANS → Run workflow**

The workflow runs the same container and uploads `results/` as a workflow artifact.

## Experimental loop

```text
BEANS seed genotype
        ↓
ADAS Meta Agent Search
        ↓
generate / mutate / reflect
        ↓
BEANS scenario evaluator
        ↓
trajectory qualification
        ↓
mission / omission / N-K / authority /
propagation / feasibility / recovery /
human-burden / false-closure scores
        ↓
gated fitness
        ↓
ADAS archive
        └────────↺
```

## Candidate genotype

ADAS's candidate `code` field contains serialized JSON rather than executable candidate Python:

- mission;
- preamble;
- principles;
- recursive operators/questions;
- operator order;
- activation policy;
- context/state rules;
- termination/reopening rule.

This deliberately removes ADAS's normal generated-code `exec()` boundary from BEANS candidate evaluation while retaining Meta Agent Search.

## Initial scenario suite

Search/validation:

- hidden lifecycle/recovery omission;
- deadline contraction;
- human authority boundary;
- `N` versus surfaced `K` collapse.

Held-back evaluation:

- stale upstream assumption and invalidation propagation;
- partial execution failure and false closure.

These are starter synthetic tests, not a claim of complete qualification.

## Deliberately excluded

No PostgreSQL. No Neo4j. No FastAPI. No Celery. No React/UI. No .NET. No second agent framework. No separate simulation server.

OR-Tools is not installed until a concrete scenario needs a deterministic constraint/feasibility oracle.

## Files

```text
RUN_BEANS.cmd          double-click launcher
run_beans.ps1          disposable-key local runner
Dockerfile             pinned ADAS runtime
beans/                  BEANS ADAS adapter + seed + scenarios
.github/workflows/      optional GitHub one-click run
results/                generated experiment output
```
