defmodule ElixirBasics.Lessons.GenServerLesson do
  use GenServer

  def start_link(initial \\ 0) do
    GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  end

  @impl true
  def init(initial) do
    {:ok, initial}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:reset, _from, state) do
    {:reply, state, 0}
  end

  @impl true
  def handle_cast(:inc, state) do
    {:noreply, state + 1}
  end

  @impl true
  def handle_info(:tick, state) do
    IO.puts("Tick! State is #{state}")
    {:noreply, state}
  end

  # Client API
  def inc do
    GenServer.cast(__MODULE__, :inc)
  end

  # Client API
  def get do
    GenServer.call(__MODULE__, :get)
  end

  # Client API
  def reset do
    GenServer.call(__MODULE__, :reset)
  end

  def run do
    {:ok, pid} = start_link(0)
    IO.puts(String.duplicate("--", 20))
    IO.puts("GenServer Started #{inspect(pid)}")

    send(Process.whereis(__MODULE__), :tick)
    # barrier: :tick is in the mailbox before :get, so it's processed first
    get()

    inc()
    inc()
    inc()
    IO.puts("Current State: #{get()}")

    reset()
    send(Process.whereis(__MODULE__), :tick)
    # barrier: ensures :tick fires after reset, before incs
    get()

    inc()
    inc()
    send(Process.whereis(__MODULE__), :tick)
    # barrier: drains all pending messages
    IO.puts("Final State: #{get()}")
  end
end
