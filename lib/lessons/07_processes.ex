defmodule ElixirBasics.Lessons.Processes do

  # ── 1. Spawn & PIDs ──────────────────────────────────────────────────
  # spawn/1 creates a new lightweight process and returns its PID.
  # Each process has its own memory — they share nothing by default.
  defp demo_spawn do
    IO.puts("Main PID: #{inspect(self())}")   # self() = current process PID

    pid = spawn(fn ->
      IO.puts("Child PID: #{inspect(self())}")   # different from main
    end)

    IO.puts("Spawned: #{inspect(pid)}")
    Process.sleep(100)   # give the child time to print before run/0 ends
  end

  # ── 2. Send & Receive ────────────────────────────────────────────────
  # Processes communicate by passing messages — no shared state.
  # send/2 puts a message in the target's mailbox (non-blocking).
  # receive do ... end blocks until a matching message arrives.
  defp demo_send_receive do
    pid = spawn(fn ->
      receive do
        {:hello, sender} ->
          IO.puts("Child got hello from #{inspect(sender)}")
      end
    end)

    send(pid, {:hello, self()})   # send our PID so the child knows who we are
    Process.sleep(100)
  end

  # ── 3. Ping / Pong (request–reply) ───────────────────────────────────
  # The `after` timeout in receive prevents blocking forever.
  # If no message arrives within N ms, the after clause runs instead.
  defp demo_ping_pong do
    pid = spawn(fn ->
      receive do
        {:ping, sender} ->
          IO.puts("Child: got ping, sending pong")
          send(sender, {:pong, self()})   # reply back to the caller
      end
    end)

    send(pid, {:ping, self()})

    receive do
      {:pong, from} ->
        IO.puts("Main: got pong from #{inspect(from)}")
    after
      1000 -> IO.puts("Main: timed out waiting for pong")   # safety net
    end
  end

  # ── 4. Monitor (observe crash without dying) ─────────────────────────
  # Process.monitor/1 subscribes to a process's exit events.
  # When the monitored process dies, we receive a {:DOWN, ...} message.
  # Unlike spawn_link, the monitoring process does NOT crash with it.
  defp demo_monitor do
    pid = spawn(fn ->
      receive do
        {:ping, sender} ->
          send(sender, {:pong, self()})
          raise "intentional crash"   # crashes AFTER sending pong
      end
    end)

    Process.monitor(pid)   # start watching this process
    send(pid, {:ping, self()})

    receive do
      {:pong, from} -> IO.puts("Got pong from #{inspect(from)}")
    end

    # After the crash, we receive a :DOWN notification (not a crash ourselves)
    receive do
      {:DOWN, _ref, :process, ^pid, reason} ->   # ^ pins pid to match exact PID
        IO.puts("Process #{inspect(pid)} died: #{inspect(reason)}")
    end
  end

  # ── 5. spawn_link (crash propagates to caller) ───────────────────────
  # spawn_link/1 links two processes — if one crashes, the other crashes too.
  # This is the basis of supervision: a supervisor is linked to its children.
  defp demo_spawn_link do
    # Uncomment to see the whole program crash:
    # spawn_link(fn -> raise "linked crash!" end)
    # Process.sleep(100)
    IO.puts("(spawn_link demo skipped — would crash the VM)")
  end

  # ── 6. Stateful loop (the heart of GenServer) ────────────────────────
  # A recursive function that holds state in its argument.
  # receive blocks waiting for a message; pattern match decides what to do.
  # After handling, loop/1 calls itself with updated state — this IS GenServer.
  defp loop(count) do
    receive do
      {:inc, sender} ->
        send(sender, {:count, count + 1})
        loop(count + 1)   # tail call — new state is count + 1

      {:get, sender} ->
        send(sender, {:count, count})
        loop(count)       # state unchanged, keep listening

      :stop ->
        IO.puts("Counter stopped at #{count}")
        # no recursive call — process exits naturally
    end
  end

  defp demo_loop do
    pid = spawn(fn -> loop(0) end)   # start counter at 0

    send(pid, {:inc, self()})
    send(pid, {:inc, self()})
    send(pid, {:inc, self()})
    send(pid, {:get, self()})   # the three :inc messages are processed before :get

    # Only collect the LAST reply (:get) — the :inc replies are already in mailbox
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
