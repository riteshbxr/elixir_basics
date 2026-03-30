defmodule ElixirBasics.Lessons.Tasks do
  # ── 1. Task.async + Task.await ────────────────────────────────────────
  # Task.async/1 spawns a task linked to the caller and returns a Task struct.
  # Task.await/1 blocks until the task finishes and returns its result.
  # The key benefit: you can do other work BETWEEN async and await.
  defp singleTask do
    tasks =
      Task.async(fn ->
        Process.sleep(500)
        "result after 500 ms"
      end)

    IO.puts("Doing other work while waiting for the task to complete...")
    result = Task.await(tasks)   # blocks here until task finishes
    IO.puts("Task completed with result: #{result}")
  end

  # ── 2. Task.await_many — fan-out ──────────────────────────────────────
  # Spawn many tasks at once, then collect ALL results in one call.
  # Results are returned in the same order as the tasks list, not completion order.
  # The timeout applies to all tasks together, not each individually.
  defp concurrentTasks do
    tasks =
      Enum.map(1..5, fn i ->
        Task.async(fn ->
          Process.sleep(100 * i)
          "result from task #{i} after #{100 * i} ms"
        end)
      end)

    results = Task.await_many(tasks, 600)   # wait up to 600ms for ALL tasks
    IO.inspect(results, label: "squares")
  end

  # ── 3. Task.async_stream — parallel map ───────────────────────────────
  # Like Enum.map but runs each element concurrently.
  # Results are wrapped in {:ok, value} tuples.
  # Respects order: results come back in input order, not completion order.
  defp streamTasks do
    1..5
    |> Task.async_stream(fn i ->
      Process.sleep(i * 200)
      i * i
    end)
    |> Enum.to_list()
    |> IO.inspect(label: "stream results")
  end

  # ── 4. Task.async_stream with per-element error handling ──────────────
  # Task.async links tasks to the caller — an unhandled exception crashes both.
  # Wrapping the body in try/rescue isolates failures per element.
  # The stream result is {:ok, value} for each element (including error tuples).
  defp streamWithErrors do
    [1, 2, :boom, 4, 5]
    |> Task.async_stream(
      fn item ->
        try do
          if item == :boom, do: raise("bad item!"), else: item * 10
        rescue
          e -> {:error, Exception.message(e)}   # turn exception into data
        end
      end,
      on_timeout: :kill_task
    )
    |> Enum.map(fn
      {:ok, {:error, reason}} -> "error: #{inspect(reason)}"   # our wrapped error
      {:ok, val} -> val                                         # normal result
    end)
    |> IO.inspect(label: "with errors")
  end

  # ── 5. Task.yield — non-blocking check ───────────────────────────────
  # Task.yield(task, timeout) checks if the task is done within timeout ms:
  #   {:ok, result}  — task finished
  #   nil            — still running (timeout elapsed)
  # If nil, you must call Task.shutdown/1 to cancel — otherwise it keeps running.
  defp yieldTask do
    task1 =
      Task.async(fn ->
        Process.sleep(300)
        "slow result"
      end)

    # task1 takes 300ms but we only wait 100ms → nil (not done yet)
    case Task.yield(task1, 100) do
      {:ok, result} ->
        IO.puts("Task1 completed with result: #{result}")

      nil ->
        IO.puts("Task1 is still running, killing it...")
        Task.shutdown(task1)   # cancel — always pair yield nil with shutdown
    end

    task2 =
      Task.async(fn ->
        Process.sleep(50)
        "slow result"
      end)

    # task2 takes 50ms and we wait 100ms → {:ok, result} (done in time)
    case Task.yield(task2, 100) do
      {:ok, result} ->
        IO.puts("Task2 completed with result: #{result}")

      nil ->
        IO.puts("Task2 is still running, killing it...")
        Task.shutdown(task2)
    end
  end

  # ── 6. Task.yield_many — fan-in with deadline ─────────────────────────
  # Like yield but for a list of tasks — returns [{task, result_or_nil}].
  # Great for "collect what's ready within a time budget, cancel the rest".
  defp fanOutFanIn do
    tasks =
      Enum.map(1..5, fn i ->
        Task.async(fn ->
          Process.sleep(i * 100)
          "source_#{i} result"
        end)
      end)

    # Wait 350ms — tasks 1-3 finish (100/200/300ms), tasks 4-5 do not (400/500ms)
    results =
      Task.yield_many(tasks, 350)
      |> Enum.map(fn {task, result} ->
        case result do
          {:ok, val} ->
            val

          nil ->
            Task.shutdown(task)             # cancel tasks that didn't finish
            {:error, "source timed out"}

          {:exit, reason} ->
            "crashed: #{inspect(reason)}"
        end
      end)

    IO.inspect(results, label: "fan-in results")
  end

  def run do
    IO.puts(String.duplicate("--", 20) <> " Running Tasks Lesson " <> String.duplicate("--", 20))
    singleTask()

    IO.puts(
      String.duplicate("--", 20) <> " Running Concurrent Tasks " <> String.duplicate("--", 20)
    )

    concurrentTasks()
    IO.puts(String.duplicate("--", 20) <> " Running Stream Tasks " <> String.duplicate("--", 20))
    streamTasks()

    IO.puts(
      String.duplicate("--", 20) <>
        " Running Stream Tasks with Errors " <> String.duplicate("--", 20)
    )

    streamWithErrors()
    IO.puts(String.duplicate("--", 20) <> " Running Yield Task " <> String.duplicate("--", 20))
    yieldTask()

    IO.puts(
      String.duplicate("--", 20) <> " Running Fan-Out/Fan-In Task " <> String.duplicate("--", 20)
    )

    fanOutFanIn()
  end
end
