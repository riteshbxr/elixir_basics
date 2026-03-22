defmodule ElixirBasics.Lessons.Tasks do
  defp singleTask do
    tasks =
      Task.async(fn ->
        Process.sleep(500)
        "result after 500 ms"
      end)

    IO.puts("Doing other work while waiting for the task to complete...")
    result = Task.await(tasks)
    IO.puts("Task completed with result: #{result}")
  end

  defp concurrentTasks do
    tasks =
      Enum.map(1..5, fn i ->
        Task.async(fn ->
          Process.sleep(100 * i)
          "result from task #{i} after #{100 * i} ms"
        end)
      end)

    results = Task.await_many(tasks, 600)
    IO.inspect(results, label: "squares")
  end

  defp streamTasks do
    1..5
    |> Task.async_stream(fn i ->
      Process.sleep(i * 200)
      i * i
    end)
    |> Enum.to_list()
    |> IO.inspect(label: "stream results")
  end

  defp streamWithErrors do
    [1, 2, :boom, 4, 5]
    |> Task.async_stream(
      fn item ->
        try do
          if item == :boom, do: raise("bad item!"), else: item * 10
        rescue
          e -> {:error, Exception.message(e)}
        end
      end,
      on_timeout: :kill_task
    )
    |> Enum.map(fn
      {:ok, {:error, reason}} -> "error: #{inspect(reason)}"
      {:ok, val} -> val
    end)
    |> IO.inspect(label: "with errors")
  end

  defp yieldTask do
    task1 =
      Task.async(fn ->
        Process.sleep(300)
        "slow result"
      end)

    case Task.yield(task1, 100) do
      {:ok, result} ->
        IO.puts("Task1 completed with result: #{result}")

      nil ->
        IO.puts("Task1 is still running, killing it...")
        Task.shutdown(task1)
    end

    task2 =
      Task.async(fn ->
        Process.sleep(50)
        "slow result"
      end)

    case Task.yield(task2, 100) do
      {:ok, result} ->
        IO.puts("Task2 completed with result: #{result}")

      nil ->
        IO.puts("Task2 is still running, killing it...")
        Task.shutdown(task2)
    end
  end

  defp fanOutFanIn do
    tasks =
      Enum.map(1..5, fn i ->
        Task.async(fn ->
          Process.sleep(i * 100)
          "source_#{i} result"
        end)
      end)

    results =
      Task.yield_many(tasks, 350)
      |> Enum.map(fn {task, result} ->
        case result do
          {:ok, val} ->
            val

          nil ->
            Task.shutdown(task)
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
