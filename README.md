# BEANS

**Beginning to End Architectural Navigation System**

This repository is the runnable BEANS seed-evolution experiment.

**Primary engine:** [`ShengranHu/ADAS`](https://github.com/ShengranHu/ADAS), pinned to upstream commit `2702bee8fefda42255efc5be9f60e3bd3db96ae4`.

BEANS uses ADAS Meta Agent Search to generate, mutate, reflect on, evaluate, and archive BEANS seed candidates. The experiment optimizes the seed itself—not another surrounding platform.

## One click and go

**Prerequisite:** Docker Desktop.

Double-click:

```text
RUN_BEANS.cmd
```

The launcher:

1. builds the pinned ADAS + BEANS image;
2. starts the local BEANS UI;
3. opens `http://127.0.0.1:8765` automatically.

In the page:

1. paste a one-time OpenAI API key;
2. optionally change generations/models;
3. click **Start**.

The key is not written to a file or repository. It is held only by the running container process for the experiment and removed from the process environment when the run exits.

The UI shows live phase/status messages and, when complete, displays the **full report** directly in the page with links to download:

- `BEANS_FULL_REPORT.md`;
- the raw ADAS candidate archive.

All raw trajectory/judge evidence is retained under local `results/`.

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

## Full report

At the end of a run BEANS writes `results/BEANS_FULL_REPORT.md`, containing:

- experiment result summary;
- complete candidate archive table;
- search and held-back fitness;
- per-candidate scenario evidence;
- hard-failure status;
- multidimensional grader scores;
- evaluator notes;
- latest evolved BEANS seed;
- interpretation/qualification cautions;
- pointers to raw evidence.

## Deliberately excluded

No PostgreSQL. No Neo4j. No FastAPI. No Celery. No React/UI framework. No .NET. No second agent framework. No separate simulation server.

The web interface is served with the Python standard library from the same BEANS process.

OR-Tools is not installed until a concrete scenario needs a deterministic constraint/feasibility oracle.

## Repository shape

```text
RUN_BEANS.cmd          double-click launcher
run_beans.ps1          builds/runs Docker and opens browser
Dockerfile             pinned ADAS runtime
beans/app.py            BEANS ADAS adapter + UI + evaluator + report
beans/main.py           safe HTTP entrypoint
.github/workflows/ci.yml Docker-build verification
results/                generated locally; gitignored
```
