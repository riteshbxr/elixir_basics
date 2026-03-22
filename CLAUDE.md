# Elixir Basics — Learning Project

## Objective
Step-by-step Elixir learning project where the user types all code themselves
(no auto-generated files). Each lesson is a standalone module in `lib/lessons/`.
Claude acts as an interactive tutor: explains one concept at a time, shows a
small snippet to type, verifies the file, then moves on.

## Learning Style
- User types every snippet themselves — builds muscle memory
- Snippets are small (≤10 lines) — one concept at a time
- After each snippet: user says "done", Claude reads the file, runs it, gives feedback
- User is encouraged to go beyond the snippet (they often do)
- Claude does NOT create files — only reads, runs, and gives feedback

## How to Run a Lesson

**Preferred — via Mix aliases (short form):**
```bash
mix basics
mix functions
mix control_flow
mix collections
mix recursion_enum
mix structs
mix processes
mix genserver
```

**Via custom Mix task directly:**
```bash
mix run_lesson basics
mix run_lesson functions
mix run_lesson control_flow
mix run_lesson collections
mix run_lesson recursion_enum
mix run_lesson structs
mix run_lesson processes
mix run_lesson genserver
```

**Via `mix run` (fallback):**
```bash
mix run -e "ElixirBasics.Lessons.<ModuleName>.run()"
```

**Other useful commands:**
```bash
mix setup        # install deps
mix check        # run Dialyzer static analysis
```

The task is defined in `lib/mix/tasks/run_lesson.ex`.
New lessons need to be registered there AND as an alias in `mix.exs`.

## Completed Lessons

### Step 1 — Basic Types & Pattern Matching
**File:** `lib/lessons/01_basics.ex` _(auto-generated, not hand-typed)_
**Module:** `ElixirBasics.Lessons.Basics`
- Integer, float, atom, string, boolean
- Immutability and rebinding
- `=` as match operator
- `[head | tail]` list matching
- `_` wildcard, `^` pin operator

### Step 2 — Functions, Modules & Pipe Operator
**File:** `lib/lessons/02_functions.ex` _(hand-typed)_
**Module:** `ElixirBasics.Lessons.Functions`
- Named functions: `def`, multi-clause pattern matching on args
- Default args: `def repeat(msg, times \\ 3)`
- Guard clauses: `when n > 0`
- `@spec` typespecs
- Anonymous functions: `fn a, b -> a + b end`
- Capture shorthand: `&(&1 * 2)`, `&String.upcase/2`, `&classify/1`
- Pipe operator: `name |> String.trim() |> String.downcase()`
- Key gotcha: anonymous functions called with dot — `fun.(args)`

### Step 3 — Control Flow
**File:** `lib/lessons/03_control_flow.ex` _(hand-typed)_
**Module:** `ElixirBasics.Lessons.ControlFlow`
- `if` / `else` — expressions, return values
- `cond` — multiple conditions, replaces nested `if`
- `case` — pattern match on a value's structure
- `with` — chain steps that can fail; `else` handles mismatches
- Returning tagged tuples `{:ok, val}` / `{:error, reason}`
- Key rule: `if`=one condition, `cond`=many conditions, `case`=one value many shapes, `with`=chain of fallible steps

### Step 4 — Collections
**File:** `lib/lessons/04_collections.ex` _(hand-typed)_
**Module:** `ElixirBasics.Lessons.Collections`
- List: `[head | tail]`, prepend, `Enum.reverse`, `++`
- Tuple: `{:ok, val}`, `elem/2`, pattern destructuring
- Map: `%{key: val}`, `.key` and `[:key]` access, `%{map | key: new}`, `Map.put`, `Map.delete`
- Keyword list: `[key: val]` sugar, duplicate keys, `Keyword.get/2`, `Keyword.get_values/2`
- Partial map pattern matching: `%{name: name} = user`
- `typeof/1` helper built with `cond` + `is_*` guards
- When to use each: List=sequence, Tuple=fixed structure, Map=unique keys, Keyword=options/config

### Step 5 — Recursion & Enum
**File:** `lib/lessons/05_recursion_enum.ex` _(hand-typed)_
**Module:** `ElixirBasics.Lessons.RecursionEnum`
- Manual recursion: base case + recursive clause (`sum/1`, `factorial/1`)
- Tail recursion with accumulator: `sum_tail/2` — stack-safe, TCO
- `Enum.map` — transform every element
- `Enum.filter` — keep matching elements
- `Enum.reduce` — fold into any shape (number, map, string)
- `Enum.take` / `Enum.drop` — slice a list
- Charlist gotcha: `[8, 9, 10]` displays as `~c"\b\t\n"` — use `inspect(..., charlists: :as_lists)`

### Step 6 — Structs
**File:** `lib/lessons/06_structs.ex` _(hand-typed)_
**Module:** `ElixirBasics.Lessons.Structs`
- `defstruct` with default values: `defstruct name: "Anonymous", age: 0`
- Creating instances: `%User{}`, `%User{name: "Ritesh"}`
- Accessing fields: `user.name`
- Updating: `%{user | age: 31}` — same syntax as maps
- Pattern matching on struct fields: `def greet(%User{role: :admin})`
- Binding whole struct in arg: `def promote(user = %User{})`
- `@enforce_keys` — required fields, enforced at compile time
- Mixed field syntax: `defstruct [:title, :body, status: :draft]`
- Constructor convention: `def new(title, body)` inside the struct module
- Structs reject unknown fields at **compile time** — unlike plain maps

### Step 7 — Processes & Message Passing
**File:** `lib/lessons/07_processes.ex` _(hand-typed)_
**Module:** `ElixirBasics.Lessons.Processes`
- `spawn/1` — create a process, get a PID
- `self/0` — current process PID
- `send/2` / `receive do` — message passing, pattern matching on messages
- `receive` with `after` — timeout to avoid blocking forever
- `spawn_link/1` — crash propagation between linked processes
- `Process.monitor/1` — observe crashes via `{:DOWN, ...}` without dying
- Recursive `loop/1` with accumulator — stateful long-lived process (foundation of GenServer)
- Key insight: `receive` blocks; `after` prevents deadlock; linked processes are a supervision unit

### Step 8 — GenServer
**File:** `lib/lessons/08_gen_server.ex` _(hand-typed)_
**Module:** `ElixirBasics.Lessons.GenServerLesson`
- `use GenServer` + `init/1` — start with initial state
- `handle_call/3` — synchronous request/reply, returns `{:reply, val, new_state}`
- `handle_cast/2` — async fire-and-forget, returns `{:noreply, new_state}`
- `handle_info/2` — catch-all for raw `send/2`, timers, monitor messages
- `name: __MODULE__` — register by name, look up with `Process.whereis/1`
- Client API pattern — public functions wrapping `GenServer.call/cast`
- `call` as synchronization barrier — drains mailbox, eliminates cast/send race conditions
- `handle_cast` vs `handle_info`: cast = your API, info = external/system messages

### Step 9 — Supervisor
**File:** `lib/lessons/09_supervisor.ex` _(hand-typed)_
**Modules:** `ElixirBasics.Lessons.SupervisorLesson`, `ElixirBasics.Lessons.Counter2`
- `Supervisor.start_link/2` with a children list and strategy
- Child spec: `{Module, init_arg}` — Supervisor calls `start_link` automatically
- `Process.exit(pid, :kill)` — hard kill to trigger restart
- `:one_for_one` — only crashed child restarts
- `:one_for_all` — all children restart when one crashes
- `:rest_for_one` — crashed child + all children defined after it restart
- `Supervisor.stop/1` — clean teardown
- Key insight: PID changes on restart, state resets to `init` value
- Parameterised `strategyCheck/2` with crash candidate — elegant way to compare all strategies

## Upcoming Lessons

| Step | Topic | File |
|------|-------|------|
| 10 | Tasks & async | `lib/lessons/10_tasks.ex` |

## Project Setup
- Elixir ~> 1.19
- Mix project: `mix.exs`
- Dialyxir configured for static analysis: `mix check`
- Custom Mix task: `lib/mix/tasks/run_lesson.ex` — dispatches to lesson modules
- Mix aliases in `mix.exs` — short names like `mix structs` map to `mix run_lesson structs`
- When adding a new lesson: register in BOTH `run_lesson.ex` AND `mix.exs` aliases

## Key Patterns Observed in User's Code
- User consistently goes beyond the snippet — explores APIs, adds extra cases
- User uses `@spec` typespecs proactively
- User preserves "reference" versions of functions with `_` prefix (e.g. `_check_age_with_if`)
- User prefers pipe-style code (`|>`) even when not explicitly shown
- User uses `inspect/1` and separators (`String.duplicate("--", N)`) for readable output

## Note to Agent
- Keep updating tihs file after every Lesson