# Elixir Basics — Interactive Learning Tutorial

A hands-on, step-by-step Elixir learning project where **you type every line of code yourself** — no copy-pasting. Each lesson is a self-contained module covering one topic. The goal is to build real muscle memory alongside conceptual understanding.


## Philosophy

- **You type everything.** Snippets are small (≤10 lines) so each one is approachable.
- **One concept at a time.** No lesson tries to cover everything at once.
- **Run and verify immediately.** After each snippet, run the lesson and see output.
- **Go beyond.** Once you understand the snippet, experiment freely.

## Prerequisites

- [Elixir](https://elixir-lang.org/install.html) ~> 1.19
- [Mix](https://hexdocs.pm/mix/Mix.html) (bundled with Elixir)

```bash
# Verify your install
elixir --version
mix --version
```

## Setup

```bash
git clone git@github.com:riteshbxr/elixir_basics.git
cd elixir_basics
mix setup        # install dependencies
```

## How to Work Through the Lessons

Each lesson lives in `lib/lessons/` as a standalone `.ex` file. Work through them in order:

| Step | Topic | File | Run with |
|------|-------|------|----------|
| 1 | Basic Types & Pattern Matching | `lib/lessons/01_basics.ex` | `mix basics` |
| 2 | Functions, Modules & Pipe Operator | `lib/lessons/02_functions.ex` | `mix functions` |
| 3 | Control Flow | `lib/lessons/03_control_flow.ex` | `mix control_flow` |
| 4 | Collections | `lib/lessons/04_collections.ex` | `mix collections` |
| 5 | Recursion & Enum | `lib/lessons/05_recursion_enum.ex` | `mix recursion_enum` |
| 6 | Structs | `lib/lessons/06_structs.ex` | `mix structs` |
| 7 | Processes & Message Passing | `lib/lessons/07_processes.ex` | `mix processes` |
| 8 | GenServer | `lib/lessons/08_gen_server.ex` | `mix genserver` |
| 9 | Supervisors | `lib/lessons/09_supervisor.ex` | `mix supervisor` |
| 10 | Tasks & Async | `lib/lessons/10_tasks.ex` | `mix tasks` |
| 11 | Behaviours | `lib/lessons/11_behaviours.ex` | `mix behaviours` |
| 12 | Application + Registry + DynamicSupervisor | `lib/lessons/12_application_otp.ex` | `mix application_otp` |
| 13 | Protocols | `lib/lessons/13_protocols.ex` | `mix protocols` |
| 14 | Ecto | `lib/lessons/14_ecto.ex` | `mix ecto_lesson` |
| 15 | Streams | `lib/lessons/15_streams.ex` | `mix streams` |
| 16 | Macros & `use` | `lib/lessons/16_macros.ex` | `mix macros` |

### Workflow for each lesson

1. **Open** the lesson file (or create it fresh if it doesn't exist yet).
2. **Read** the concept at the top — understand what you're about to type.
3. **Type** the code snippet by hand into the file.
4. **Run** it with the `mix` alias for that lesson (e.g. `mix functions`).
5. **Experiment** — change values, break things, add your own functions.
6. Repeat for the next snippet in the lesson.

## Running Lessons

```bash
# Short form (recommended)
mix basics
mix functions
mix control_flow
mix collections
mix recursion_enum
mix structs
mix processes
mix genserver
mix supervisor
mix tasks

# Or via the custom Mix task
mix run_lesson basics
mix run_lesson functions
# ... etc.
```

## What Each Lesson Covers

### Step 1 — Basic Types & Pattern Matching
Integers, floats, atoms, strings, booleans. The `=` match operator (not assignment!), `[head | tail]` list matching, `_` wildcard, `^` pin operator.

### Step 2 — Functions, Modules & Pipe Operator
Named functions with `def`, multi-clause pattern matching, default args, guard clauses, `@spec` typespecs. Anonymous functions (`fn`), capture shorthand (`&`), and the pipe operator `|>`.

### Step 3 — Control Flow
`if`, `cond`, `case`, and `with`. Returning tagged tuples `{:ok, val}` / `{:error, reason}`. Know when to use each: `if`=one condition, `cond`=many conditions, `case`=one value many shapes, `with`=chain of fallible steps.

### Step 4 — Collections
Lists, tuples, maps, and keyword lists. When to use each. Partial map pattern matching, `Map.put/delete`, `Keyword.get_values/2`.

### Step 5 — Recursion & Enum
Manual recursion with base + recursive cases. Tail recursion with accumulators for stack safety. `Enum.map`, `Enum.filter`, `Enum.reduce`, `Enum.take/drop`.

### Step 6 — Structs
`defstruct` with defaults, `@enforce_keys`, pattern matching on struct fields, binding the whole struct in a function argument. Constructor convention with `new/2`.

### Step 7 — Processes & Message Passing
`spawn`, `self`, `send`/`receive`, `after` timeout, `spawn_link`, `Process.monitor`. Building a stateful long-lived process with a recursive loop — the manual precursor to GenServer.

### Step 8 — GenServer
`use GenServer`, `init/1`, `handle_call/3` (sync), `handle_cast/2` (async), `handle_info/2` (raw messages). Named registration, the client API pattern, using `call` as a synchronization barrier.

### Step 9 — Supervisors
`Supervisor.start_link/2`, child specs, `:one_for_one`, `:one_for_all`, `:rest_for_one` strategies. How PIDs change on restart and how state resets.

### Step 10 — Tasks & Async
`Task.async/await`, `Task.await_many`, `Task.async_stream` (parallel map over collections), `Task.yield` (non-crashing timeout check), `Task.yield_many` (fan-in: collect results within a time budget, cancel the rest). Key insight: `Task.async` links tasks to the caller — use `try/rescue` inside tasks to isolate failures.

### Step 11 — Behaviours _(upcoming)_
`@callback`, `@optional_callbacks`, `@impl`, `@behaviour`. Defining interface contracts and swapping implementations via config.

### Step 12 — Application + Registry + DynamicSupervisor _(upcoming)_
`use Application`, `start/2`, starting supervisor trees at boot. `Registry` for named process lookup. `DynamicSupervisor` for spawning workers at runtime.

### Step 13 — Protocols _(upcoming)_
`defprotocol`, `defimpl`, dispatching on type. Elixir's polymorphism without inheritance.

### Step 14 — Ecto _(upcoming)_
Schemas, changesets, validation, `Ecto.Query`, `Ecto.Multi` for atomic transactions.

### Step 15 — Streams _(upcoming)_
Lazy evaluation with `Stream.map/filter/unfold`. Composing infinite or large sequences without loading everything into memory.

### Step 16 — Macros & `use` _(upcoming)_
`defmacro`, `quote/unquote`, `__using__/1`. Building DSLs that bootstrap module boilerplate.

## Other Useful Commands

```bash
mix check        # run Dialyzer static analysis
mix test         # run tests
```

## Project Structure

```
lib/
  lessons/           # one file per lesson — you type these
  mix/tasks/
    run_lesson.ex    # custom Mix task that dispatches to lesson modules
mix.exs              # Mix aliases for short-form lesson commands
CLAUDE.md            # detailed notes for AI-assisted learning sessions
```

## Tips

- If a lesson file doesn't exist yet, create it and add the module skeleton before typing the snippets.
- Use `IO.inspect/2` liberally — label everything so output is easy to read.
- `iex -S mix` drops you into an interactive shell with your project loaded. Great for experimenting.
- Dialyzer (`mix check`) will catch type errors before runtime — run it after completing a lesson.
