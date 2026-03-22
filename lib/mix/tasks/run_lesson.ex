defmodule Mix.Tasks.RunLesson do
  use Mix.Task

  @shortdoc "Runs a lesson module. Usage: mix run_lesson functions"

  def run(["functions"]), do: ElixirBasics.Lessons.Functions.run()
  def run(["basics"]), do: ElixirBasics.Lessons.Basics.run()
  def run(["control_flow"]), do: ElixirBasics.Lessons.ControlFlow.run()
  def run(["collections"]), do: ElixirBasics.Lessons.Collections.run()
  def run(["recursion_enum"]), do: ElixirBasics.Lessons.RecursionEnum.run()
  def run(["structs"]), do: ElixirBasics.Lessons.Structs.run()
  def run(["processes"]), do: ElixirBasics.Lessons.Processes.run()
  def run(_), do: Mix.shell().error("Unknown lesson. Available: functions")
end
