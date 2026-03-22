defmodule ElixirBasics.Lessons.Processes do

  # ── 1. Spawn & PIDs ──────────────────────────────────────────────────
  defp demo_spawn do
    IO.puts("Main PID: #{inspect(self())}")

    pid = spawn(fn ->
      IO.puts("Child PID: #{inspect(self())}")
    end)

    IO.puts("Spawned: #{inspect(pid)}")
    Process.sleep(100)
  end

  # ── 2. Send & Receive ────────────────────────────────────────────────
  defp demo_send_receive do
    pid = spawn(fn ->
      receive do
        {:hello, sender} ->
          IO.puts("Child got hello from #{inspect(sender)}")
      end
    end)

    send(pid, {:hello, self()})
    Process.sleep(100)
  end

  # ── 3. Ping / Pong (request–reply) ───────────────────────────────────
  defp demo_ping_pong do
    pid = spawn(fn ->
      receive do
        {:ping, sender} ->
          IO.puts("Child: got ping, sending pong")
          send(sender, {:pong, self()})
      end
    end)

    send(pid, {:ping, self()})

    receive do
      {:pong, from} ->
        IO.puts("Main: got pong from #{inspect(from)}")
    after
      1000 -> IO.puts("Main: timed out waiting for pong")
    end
  end

  # ── 4. Monitor (observe crash without dying) ─────────────────────────
  defp demo_monitor do
    pid = spawn(fn ->
      receive do
        {:ping, sender} ->
          send(sender, {:pong, self()})
          raise "intentional crash"
      end
    end)

    Process.monitor(pid)
    send(pid, {:ping, self()})

    receive do
      {:pong, from} -> IO.puts("Got pong from #{inspect(from)}")
    end

    receive do
      {:DOWN, _ref, :process, ^pid, reason} ->
        IO.puts("Process #{inspect(pid)} died: #{inspect(reason)}")
    end
  end

  # ── 5. spawn_link (crash propagates to caller) ───────────────────────
  defp demo_spawn_link do
    # Uncomment to see the whole program crash:
    # spawn_link(fn -> raise "linked crash!" end)
    # Process.sleep(100)
    IO.puts("(spawn_link demo skipped — would crash the VM)")
  end

  # ── 6. Stateful loop (the heart of GenServer) ────────────────────────
  defp loop(count) do
    receive do
      {:inc, sender} ->
        send(sender, {:count, count + 1})
        loop(count + 1)

      {:get, sender} ->
        send(sender, {:count, count})
        loop(count)

      :stop ->
        IO.puts("Counter stopped at #{count}")
    end
  end

  defp demo_loop do
    pid = spawn(fn -> loop(0) end)

    send(pid, {:inc, self()})
    send(pid, {:inc, self()})
    send(pid, {:inc, self()})
    send(pid, {:get, self()})

    receive do
      {:count, n} -> IO.puts("Current count: #{n}")
    after
      500 -> IO.puts("No count received")
    end

    send(pid, :stop)
    Process.sleep(100)
  end

  # ── Entry point ───────────────────────────────────────────────────────
  def run do
    sep = String.duplicate("─", 50)

    IO.puts("\n#{sep}\n1. Spawn & PIDs\n#{sep}")
    demo_spawn()

    IO.puts("\n#{sep}\n2. Send & Receive\n#{sep}")
    demo_send_receive()

    IO.puts("\n#{sep}\n3. Ping / Pong\n#{sep}")
    demo_ping_pong()

    IO.puts("\n#{sep}\n4. Monitor\n#{sep}")
    demo_monitor()

    IO.puts("\n#{sep}\n5. spawn_link\n#{sep}")
    demo_spawn_link()

    IO.puts("\n#{sep}\n6. Stateful Loop\n#{sep}")
    demo_loop()
  end
end
