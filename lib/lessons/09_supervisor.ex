defmodule ElixirBasics.Lessons.SupervisorLesson do
  alias ElixirBasics.Lessons.Counter2
  alias ElixirBasics.Lessons.GenServerLesson

  # ── strategyCheck/2 ────────────────────────────────────────────────────
  # Starts a Supervisor with two children, kills one, then compares PIDs
  # before/after to show which children were restarted by the strategy.
  #
  # Restart strategies:
  #   :one_for_one  — only the crashed child restarts; siblings unaffected
  #   :one_for_all  — ALL children restart when any one crashes
  #   :rest_for_one — crashed child + every child defined AFTER it restarts
  @spec strategyCheck(:one_for_one | :one_for_all | :rest_for_one) :: :ok
  def strategyCheck(strategy, crashCandidate \\ "c2") do
    IO.puts(
      "#{String.duplicate("--", 20)}#{strategy} (Crashing #{crashCandidate})#{String.duplicate("--", 20)}"
    )

    # Child spec: {Module, init_arg} — Supervisor calls Module.start_link(init_arg)
    children = [
      {GenServerLesson, 1},    # first child (init state = 1)
      {Counter2, 100}          # second child (init state = 100)
    ]

    {:ok, sup} = Supervisor.start_link(children, strategy: strategy)
    IO.puts("Supervisor PID: #{inspect(sup)}")
    GenServerLesson.inc()
    IO.puts("GenServer Counter: #{GenServerLesson.get()}")

    # Capture PIDs BEFORE the crash so we can compare after restart
    c2pid_before = GenServer.whereis(Counter2)
    gspid_before = GenServer.whereis(GenServerLesson)

    # Process.exit(pid, :kill) is a hard kill — the process cannot trap it.
    # The Supervisor detects the exit and applies the restart strategy.
    case crashCandidate do
      "c2" -> Process.exit(c2pid_before, :kill)
      "gs" -> Process.exit(gspid_before, :kill)
      _ -> IO.puts("Invalid crash candidate")
    end

    Process.sleep(100)   # give the Supervisor time to restart child(ren)

    c2pid_after = GenServer.whereis(Counter2)
    gspid_after = GenServer.whereis(GenServerLesson)

    # A changed PID means that process was restarted (new process = new PID).
    # State resets to the init value because it's a brand-new process.
    IO.puts(
      "GenServer Before: #{inspect(gspid_before)}, After C2 restart: #{inspect(gspid_after)}"
    )

    IO.puts(
      "Counter2 Before: #{inspect(c2pid_before)}, After C2 restart: #{inspect(c2pid_after)}"
    )

    IO.puts("GenServer Counter after restart: #{GenServerLesson.get()}")
    Supervisor.stop(sup)   # clean shutdown — stops all children then the supervisor
  end

  def run do
    strategyCheck(:one_for_one)            # only Counter2 restarts
    strategyCheck(:one_for_all)            # both children restart
    strategyCheck(:rest_for_one)           # Counter2 + children after it restart
    strategyCheck(:rest_for_one, "gs")    # GenServerLesson + Counter2 restart (gs is first)
  end
end

# ── Counter2 ────────────────────────────────────────────────────────────────
# A minimal GenServer used as the second child in the supervision tree.
# Keeps a simple integer counter — no mutation, returns new state on each call.
defmodule ElixirBasics.Lessons.Counter2 do
  use GenServer

  # name: __MODULE__ registers this process under its module name globally
  def start_link(initial), do: GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  def get, do: GenServer.call(__MODULE__, :get)

  @impl true
  def init(initial), do: {:ok, initial}   # state = whatever was passed to start_link

  @impl true
  def handle_call(:get, _from, state), do: {:reply, state, state}
end
