# Learning Elixir — Step by Step

This is a hands-on Elixir learning project. Each lesson introduces one concept, gives you a small code snippet to type out yourself, and lets you run it immediately to see what happens.

No copy-pasting. No reading a wall of theory before writing a line of code. Just type, run, understand, repeat.

---

## What is Elixir?

Elixir is a programming language designed for building systems that need to be **fast, reliable, and handle lots of things happening at the same time** — think chat apps, payment processors, real-time dashboards. It runs on the Erlang virtual machine, which has been used in telecoms infrastructure for 30+ years because it almost never crashes.

Elixir is also quite pleasant to write. It has clean syntax, a powerful standard library, and a way of thinking about code that feels very different from languages like Python or JavaScript — in a good way.

If you've never written Elixir before, you're in the right place.

---

## Before You Start

You need two things installed:

### 1. Elixir

Go to [https://elixir-lang.org/install.html](https://elixir-lang.org/install.html) and follow the instructions for your operating system.

Once installed, check it worked by opening a terminal and running:

```bash
elixir --version
```

You should see something like `Elixir 1.19.x`. If you get an error, Elixir isn't installed correctly yet.

### 2. Mix (comes free with Elixir)

Mix is Elixir's built-in tool for running code, managing dependencies, and doing project tasks. You don't install it separately — it comes with Elixir.

Check it's there:

```bash
mix --version
```

---

## Getting the Project

```bash
git clone git@github.com:riteshbxr/elixir_basics.git
cd elixir_basics
mix setup
```

`mix setup` downloads the small number of libraries this project uses. You only need to do this once.

---

## How This Works

Each lesson is a single file inside `lib/lessons/`. You open it, read the explanation at the top, type out the code snippet, and then run it with a short command.

### Setting up your workspace

Before starting a lesson, do this once:

**Step 1 — Copy the lesson file to a working file**

```bash
# Example: starting lesson 2
cp lib/lessons/02_functions.ex lib/lessons/00_inprogress.ex
```

`00_inprogress.ex` is your personal scratchpad for the lesson. The original lesson file stays untouched as your reference.

**Step 2 — Clear out the code in `00_inprogress.ex`**

Open `00_inprogress.ex` and delete everything inside the module body — keep only the module shell:

```elixir
defmodule ElixirBasics.Lessons.Functions do
  # you'll type the lesson code here
end
```

**Step 3 — Open both files side by side**

In VS Code: right-click `00_inprogress.ex` in the Explorer and choose **"Open to the Side"**. You'll have the original lesson on the right as a reference, and your blank working file on the left to type into.

> On a Mac you can also drag a tab to the side of the editor to split the view.

### The workflow for every lesson

1. Reference the original lesson file on the right
2. Read the next snippet and the comment explaining it — understand what it's doing before you type
3. Type it into `00_inprogress.ex` on the left. Typing (not pasting) gives your brain time to process each line
4. Run the lesson's `mix` command in the terminal to see the output

   ```bash
   mix functions   # swap 'functions' for whichever lesson you're on
   ```

5. Read the output. Does it match what you expected?
6. If something is unclear — change a value, rename a variable, delete a line. Breaking things deliberately is one of the fastest ways to understand them.
7. Once a snippet clicks, move on to the next one in the lesson.

> **On copy-pasting:** If you've genuinely understood a snippet and just want to move past it, pasting is fine. But default to typing — the few extra minutes pay off every time you write Elixir later.

---

## The Lessons

Work through these in order. Each one builds on the last.

| Step | What You'll Learn | Run Command |
|------|-------------------|-------------|
| 1 | Basic types, variables, and the `=` operator (it's not what you think) | `mix basics` |
| 2 | Writing functions, modules, and the pipe operator | `mix functions` |
| 3 | Making decisions: if, cond, case, and with | `mix control_flow` |
| 4 | Lists, maps, tuples, and when to use each | `mix collections` |
| 5 | Recursion and working with lists using Enum | `mix recursion_enum` |
| 6 | Structs — Elixir's typed data shapes | `mix structs` |
| 7 | Processes and message passing — how Elixir handles concurrency | `mix processes` |
| 8 | GenServer — the standard way to build stateful processes | `mix genserver` |
| 9 | Supervisors — making your processes restart when they crash | `mix supervisor` |
| 10 | Tasks — running things in parallel and collecting results | `mix tasks` |
| 11 | Behaviours — defining contracts between modules | `mix behaviours` |
| 12 | Application, Registry, and DynamicSupervisor | `mix application_otp` |
| 13 | Protocols — polymorphism based on data type | `mix protocols` |
| 14 | Ecto — validating and transforming data with changesets | `mix ecto_lesson` |
| 15 | Streams — lazy sequences for large or infinite data | `mix streams` |
| 16 | Macros and `use` — metaprogramming and code generation | `mix macros` |

---

## What You'll Learn in Each Lesson

### Step 1 — Basic Types & Pattern Matching

Elixir has the usual types: integers, floats, strings, booleans. But `=` doesn't mean "assign" — it means "match". This small shift in thinking is one of the most powerful ideas in the language.

You'll also learn how to pull apart a list with `[head | tail]` and how the `^` pin operator lets you check a value rather than rebind it.

### Step 2 — Functions, Modules & the Pipe Operator

Functions in Elixir are grouped inside modules. You can define the same function multiple times with different patterns — Elixir picks the right one at runtime. You'll also meet the pipe operator `|>`, which lets you chain function calls left to right instead of nesting them inside each other.

### Step 3 — Control Flow

Four tools for making decisions:
- `if` — when there's one condition
- `cond` — when there are several conditions to check
- `case` — when you want to match on the shape of a value
- `with` — when you're chaining steps that might fail, and want clean error handling

### Step 4 — Collections

Elixir's four main data containers, when to use each, and how to read and update them:
- **List** — an ordered sequence of things
- **Tuple** — a fixed-size group (often used to signal success/failure)
- **Map** — key-value pairs, like a dictionary
- **Keyword list** — an ordered list of key-value pairs, typically used for options

### Step 5 — Recursion & Enum

Elixir has no loops. Instead you use recursion (a function that calls itself) or the `Enum` module, which gives you `map`, `filter`, `reduce`, and more. You'll write both — first by hand to understand how it works, then using `Enum` the way you'd do it day to day.

### Step 6 — Structs

A struct is like a map but with a fixed set of keys that are checked at compile time. You define the shape of your data once and Elixir enforces it. Great for modelling domain objects like `User`, `Order`, or `Product`.

### Step 7 — Processes & Message Passing

This is where Elixir starts to feel very different. Instead of threads sharing memory, Elixir runs thousands of lightweight processes that communicate by sending each other messages. You'll `spawn` a process, `send` it a message, and `receive` a reply. This lesson is the foundation for everything that comes after.

### Step 8 — GenServer

GenServer ("generic server") is Elixir's standard building block for a process that holds state and responds to messages. It's what you reach for whenever you need something running in the background keeping track of data. You'll build a simple counter, then a slightly more interesting one.

### Step 9 — Supervisors

Processes crash. In most systems that's a problem. In Elixir, it's a strategy. A Supervisor watches your processes and restarts them when they die. You'll explore three restart strategies — `:one_for_one`, `:one_for_all`, and `:rest_for_one` — and see exactly how each one behaves.

### Step 10 — Tasks & Async

When you need to do several slow things at once (network calls, file reads, heavy computation), `Task` is the tool. You'll fan out work across multiple processes, collect results when they're ready, and learn how to handle partial failures without crashing everything.

### Step 11 — Behaviours

Behaviours let you define a contract — a list of functions that any implementing module must provide. Think of it like an interface in other languages. You'll define a behaviour and write two different modules that implement it, then call them interchangeably.

### Step 12 — Application + Registry + DynamicSupervisor

By this point you know the individual pieces. This lesson puts them together the way a real OTP application is structured: an Application that starts a supervision tree at boot, a Registry that lets processes find each other by name, and a DynamicSupervisor that starts new workers on demand at runtime.

### Step 13 — Protocols

Protocols are Elixir's other form of polymorphism. Where Behaviours dispatch based on which module you pass, Protocols dispatch based on what type of data you pass. You'll implement a protocol for a built-in type and for your own struct, and plug into Elixir's `to_string` system so your types work inside string interpolation.

### Step 14 — Ecto Changesets

Ecto is Elixir's data mapping and query library. Even if you're not using a database, its changeset system is the standard way to validate and transform incoming data — from a web form, an API, or anywhere else. You'll define a schema, cast raw input through it, and get back either a valid struct or a detailed list of errors.

### Step 15 — Streams

`Enum` loads everything into memory at once. `Stream` is the lazy alternative — it only processes each element when you actually ask for it. This makes it possible to work with very large files, infinite sequences, or pipelines where you want to compose transformations without paying for them upfront.

### Step 16 — Macros & `use`

Macros let you write code that generates code. They're how `use GenServer`, `use Phoenix.Controller`, and similar constructs work — they inject boilerplate into your module at compile time. This lesson lifts the lid on that mechanism so you understand what's happening when you type `use SomeModule`.

---

## Useful Commands

```bash
mix setup        # install dependencies (run once after cloning)
mix check        # run Dialyzer — catches type errors before runtime
iex -S mix       # open an interactive Elixir shell with your project loaded
```

`iex` (Interactive Elixir) is excellent for experimenting. You can call any function from your lesson files directly and see the result immediately. Try it often.

---

## Project Layout

```
lib/
  lessons/           # one file per lesson — this is where you work
  mix/tasks/
    run_lesson.ex    # the Mix task that knows how to run each lesson
mix.exs              # project config — also defines the short `mix <lesson>` commands
```

You don't need to touch anything outside `lib/lessons/` while working through the lessons.

---

## Tips That Actually Help

**Type, don't paste.** Your fingers learning the syntax is half the point. Muscle memory is real.

**Break things on purpose.** Once a snippet works, change something — remove a clause, swap a type, rename a variable. Seeing what breaks and why is often more instructive than seeing it work.

**Use `IO.inspect/2` everywhere.** Stick `|> IO.inspect(label: "after step 3")` in the middle of any pipeline to see exactly what's flowing through at that point.

**Read the error messages.** Elixir's compiler errors are unusually helpful. They often tell you not just what's wrong but what you probably meant to write instead.

**Don't skip lessons.** The topics build on each other. Supervisors are confusing without Processes. GenServer makes no sense without understanding message passing first.
