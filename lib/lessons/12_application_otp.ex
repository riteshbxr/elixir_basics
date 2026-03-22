defmodule ElixirBasics.Lessons.ApplicationOtp do
  defmodule MyApp do
    use Application

    @impl true
    def start(_type, _args) do
      children = [
        {Registry, keys: :unique, name: MyApp.Registry},
        {DynamicSupervisor, strategy: :one_for_one, name: MyApp.WorkerSupervisor}
      ]

      opts = [strategy: :one_for_one, name: MyApp.Supervisor]
      Supervisor.start_link(children, opts)
    end
  end

  defmodule Worker do
    use GenServer

    def start_link(id) do
      GenServer.start_link(__MODULE__, id, name: via(id))
    end

    def increment(id), do: GenServer.cast(via(id), :increment)
    def get_count(id), do: GenServer.call(via(id), :get_count)
    def get_id(id), do: GenServer.call(via(id), :get_id)

    defp via(id), do: {:via, Registry, {MyApp.Registry, id}}

    @impl true
    def init(id), do: {:ok, %{id: id, count: 0}}

    @impl true
    def handle_call(:get_id, _from, state), do: {:reply, state.id, state}
    @impl true
    def handle_call(:get_count, _from, state), do: {:reply, state.count, state}

    @impl true
    def handle_cast(:increment, state), do: {:noreply, %{state | count: state.count + 1}}
  end

  def start_worker(id) do
    DynamicSupervisor.start_child(MyApp.WorkerSupervisor, {Worker, id})
  end

  def run do
    IO.puts(String.duplicate("-", 40) <> "Application + Registry" <> String.duplicate("-", 40))

    
    {:ok, _} = Worker.start_link("worker-1")
    {:ok, _} = Worker.start_link("worker-2")
    Worker.increment("worker-1")
    Worker.increment("worker-1")
    Worker.increment("worker-2")

    IO.puts(
      "Worker 1 #{Worker.get_id("worker-1")}: #{Worker.get_count("worker-1")} | #{inspect(Registry.lookup(MyApp.Registry, "worker-1"))}"
    )

    IO.puts(
      "Worker 2 #{Worker.get_id("worker-2")}: #{Worker.get_count("worker-2")} | #{inspect(Registry.lookup(MyApp.Registry, "worker-2"))}"
    )

    IO.puts(
      String.duplicate("-", 40) <> "Application + DynamicSupervisor" <> String.duplicate("-", 40)
    )

    {:ok, _} = start_worker("worker-A")
    {:ok, _} = start_worker("worker-B")
    {:ok, _} = start_worker("worker-C")
    Worker.increment("worker-A")
    IO.puts("Worker A #{Worker.get_id("worker-A")}: #{Worker.get_count("worker-A")}")
    IO.puts("Worker B #{Worker.get_id("worker-B")}: #{Worker.get_count("worker-B")}")
    IO.puts("Worker C #{Worker.get_id("worker-C")}: #{Worker.get_count("worker-C")}")
    IO.puts("Children: #{inspect(DynamicSupervisor.which_children(MyApp.WorkerSupervisor))}")
  end
end
