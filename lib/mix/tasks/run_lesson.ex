defmodule Mix.Tasks.RunLesson do
  use Mix.Task

  @shortdoc "Runs a lesson module. Usage: mix run_lesson functions"

  def run(["functions"]), do: ElixirBasics.Lessons.Functions.run()
  def run(["basics"]), do: ElixirBasics.Lessons.Basics.run()
  def run(_), do: Mix.shell().error("Unknown lesson. Available: functions")
end
