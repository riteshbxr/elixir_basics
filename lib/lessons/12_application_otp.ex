defmodule ElixirBasics.Lessons.ApplicationOtp do
  # ── OTP Application ────────────────────────────────────────────────────
  # `use Application` makes this module the app's entry point.
  # The `mod:` key in mix.exs points to this module.
  # start/2 is called automatically when the OTP app boots.
  defmodule MyApp do
    use Application

    @impl true
    def start(_type, _args) do
      children = [
        # Registry — a named process lookup table.
        # keys: :unique means each name can only map to one process.
        {Registry, keys: :unique, name: MyApp.Registry},

        # DynamicSupervisor — like Supervisor but children are started at runtime,
        # not at boot. strategy: :one_for_one restarts only the crashed child.
        {DynamicSupervisor, strategy: :one_for_one, name: MyApp.WorkerSupervisor}
      ]

      # Start a top-level Supervisor that owns the Registry and DynamicSupervisor.
      opts = [strategy: :one_for_one, name: MyApp.Supervisor]
      Supervisor.start_link(children, opts)
    end
  end

  # ── Worker GenServer ───────────────────────────────────────────────────
  # Each Worker is identified by an `id` string instead of a fixed atom name.
  # The Registry lets us look up its PID dynamically using that id.
  defmodule Worker do
    use GenServer

    # via/1 returns a {:via, Registry, {registry, key}} tuple.
    # This is the "name" passed to start_link — GenServer registers itself
    # in the Registry under this key instead of a global atom.
    def start_link(id) do
      GenServer.start_link(__MODULE__, id, name: via(id))
    end

    # Public API — callers use the string id, not the PID directly.
    def increment(id), do: GenServer.cast(via(id), :increment)
    def get_count(id), do: GenServer.call(via(id), :get_count)
    def get_id(id), do: GenServer.call(via(id), :get_id)

    # Private — translates a string id to the via tuple for Registry lookup
    defp via(id), do: {:via, Registry, {MyApp.Registry, id}}

    @impl true
    def init(id), do: {:ok, %{id: id, count: 0}}   # state = map with id and counter

    @impl true
    def handle_call(:get_id, _from, state), do: {:reply, state.id, state}
    @impl true
    def handle_call(:get_count, _from, state), do: {:reply, state.count, state}

    @impl true
    def handle_cast(:increment, state), do: {:noreply, %{state | count: state.count + 1}}
  end

  # ── DynamicSupervisor helper ───────────────────────────────────────────
  # DynamicSupervisor.start_child/2 spawns a supervised child at runtime.
  # If the child crashes, the DynamicSupervisor restarts it automatically.
  def start_worker(id) do
    DynamicSupervisor.start_child(MyApp.WorkerSupervisor, {Worker, id})
  end

  def run do
    IO.puts(String.duplicate("-", 40) <> "Application + Registry" <> String.duplicate("-", 40))

    # Workers started directly (not via DynamicSupervisor) —
    # they register themselves in MyApp.Registry using their string id.
    {:ok, _} = Worker.start_link("worker-1")
    {:ok, _} = Worker.start_link("worker-2")
    Worker.increment("worker-1")
    Worker.increment("worker-1")
    Worker.increment("worker-2")

    # Registry.lookup/2 returns [{pid, value}] for the given key
    IO.puts(
      "Worker 1 #{Worker.get_id("worker-1")}: #{Worker.get_count("worker-1")} | #{inspect(Registry.lookup(MyApp.Registry, "worker-1"))}"
    )

    IO.puts(
      "Worker 2 #{Worker.get_id("worker-2")}: #{Worker.get_count("worker-2")} | #{inspect(Registry.lookup(MyApp.Registry, "worker-2"))}"
    )

    IO.puts(
      String.duplicate("-", 40) <> "Application + DynamicSupervisor" <> String.duplicate("-", 40)
    )

    # These workers ARE supervised — the DynamicSupervisor watches them
    {:ok, _} = start_worker("worker-A")
    {:ok, _} = start_worker("worker-B")
    {:ok, _} = start_worker("worker-C")
    Worker.increment("worker-A")
    IO.puts("Worker A #{Worker.get_id("worker-A")}: #{Worker.get_count("worker-A")}")
    IO.puts("Worker B #{Worker.get_id("worker-B")}: #{Worker.get_count("worker-B")}")
    IO.puts("Worker C #{Worker.get_id("worker-C")}: #{Worker.get_count("worker-C")}")

    # which_children returns [{id, pid, type, modules}] — ids are :undefined
    # because DynamicSupervisor doesn't assign ids the way static Supervisor does
    IO.puts("Children: #{inspect(DynamicSupervisor.which_children(MyApp.WorkerSupervisor))}")
  end
end
