defmodule ElixirBasics.Lessons.GenServerLesson do
  # `use GenServer` injects the GenServer behaviour and default callbacks.
  # You only need to implement the callbacks you care about.
  use GenServer

  # ── Client API ─────────────────────────────────────────────────────────
  # By convention, public functions that wrap GenServer calls live here.
  # `name: __MODULE__` registers this process under the module name,
  # so we can reach it with GenServer.call(__MODULE__, ...) from anywhere.
  def start_link(initial \\ 0) do
    GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  end

  # ── Server callbacks ────────────────────────────────────────────────────
  # @impl true tells the compiler this function implements a behaviour callback.
  # init/1 is called once when the process starts — return value sets the state.
  @impl true
  def init(initial) do
    {:ok, initial}   # state = initial value passed to start_link
  end

  # handle_call/3 — synchronous: caller BLOCKS until this returns.
  # Return {:reply, value_to_send_back, new_state}
  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}   # reply with current state, don't change it
  end

  @impl true
  def handle_call(:reset, _from, state) do
    {:reply, state, 0}   # reply with OLD state, reset stored state to 0
  end

  # handle_cast/2 — async: caller does NOT wait for a reply (fire-and-forget).
  # Return {:noreply, new_state}
  @impl true
  def handle_cast(:inc, state) do
    {:noreply, state + 1}   # update state silently, send nothing back
  end

  # handle_info/2 — handles raw messages sent with send/2 (not cast/call).
  # Used for timers, monitor :DOWN messages, and any out-of-band signals.
  @impl true
  def handle_info(:tick, state) do
    IO.puts("Tick! State is #{state}")
    {:noreply, state}   # no reply needed, just log and keep state
  end

  # ── Public client functions ─────────────────────────────────────────────
  # These are the "API" callers use — they hide the GenServer plumbing.
  def inc do
    GenServer.cast(__MODULE__, :inc)   # async, no return value
  end

  def get do
    GenServer.call(__MODULE__, :get)   # sync, returns state
  end

  def reset do
    GenServer.call(__MODULE__, :reset)   # sync, returns old state
  end

  def run do
    {:ok, pid} = start_link(0)
    IO.puts(String.duplicate("--", 20))
    IO.puts("GenServer Started #{inspect(pid)}")

    # send/2 puts :tick directly into the mailbox (handle_info handles it).
    # The following get() is a call — it acts as a synchronization barrier:
    # by the time get() returns, all earlier messages (including :tick) are processed.
    send(Process.whereis(__MODULE__), :tick)
    get()   # barrier: :tick fires before this call returns

    inc()
    inc()
    inc()
    IO.puts("Current State: #{get()}")

    reset()
    send(Process.whereis(__MODULE__), :tick)
    get()   # barrier: ensures :tick fires after reset, before next incs

    inc()
    inc()
    send(Process.whereis(__MODULE__), :tick)
    IO.puts("Final State: #{get()}")   # barrier: drains all pending messages
  end
end
