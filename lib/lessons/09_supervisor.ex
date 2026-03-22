defmodule ElixirBasics.Lessons.SupervisorLesson do
  alias ElixirBasics.Lessons.Counter2
  alias ElixirBasics.Lessons.GenServerLesson

  @spec strategyCheck(:one_for_one | :one_for_all | :rest_for_one) :: :ok
  def strategyCheck(strategy, crashCandidate \\ "c2") do
    IO.puts(
      "#{String.duplicate("--", 20)}#{strategy} (Crashing #{crashCandidate})#{String.duplicate("--", 20)}"
    )

    children = [
      {GenServerLesson, 1},
      {Counter2, 100}
    ]

    {:ok, sup} = Supervisor.start_link(children, strategy: strategy)
    IO.puts("Supervisor PID: #{inspect(sup)}")
    GenServerLesson.inc()
    IO.puts("GenServer Counter: #{GenServerLesson.get()}")

    c2pid_before = GenServer.whereis(Counter2)
    gspid_before = GenServer.whereis(GenServerLesson)

    case crashCandidate do
      "c2" -> Process.exit(c2pid_before, :kill)
      "gs" -> Process.exit(gspid_before, :kill)
      _ -> IO.puts("Invalid crash candidate")
    end

    Process.sleep(100)

    c2pid_after = GenServer.whereis(Counter2)
    gspid_after = GenServer.whereis(GenServerLesson)

    IO.puts(
      "GenServer Before: #{inspect(gspid_before)}, After C2 restart: #{inspect(gspid_after)}"
    )

    IO.puts(
      "Counter2 Before: #{inspect(c2pid_before)}, After C2 restart: #{inspect(c2pid_after)}"
    )

    IO.puts("GenServer Counter after restart: #{GenServerLesson.get()}")
    Supervisor.stop(sup)
  end

  def run do
    strategyCheck(:one_for_one)
    strategyCheck(:one_for_all)
    strategyCheck(:rest_for_one)
    strategyCheck(:rest_for_one, "gs")
  end
end

defmodule ElixirBasics.Lessons.Counter2 do
  use GenServer

  def start_link(initial), do: GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  def get, do: GenServer.call(__MODULE__, :get)

  @impl true
  def init(initial), do: {:ok, initial}

  @impl true
  def handle_call(:get, _from, state), do: {:reply, state, state}
end
