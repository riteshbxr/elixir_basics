defmodule Mix.Tasks.RunLesson do
  use Mix.Task

  @shortdoc "Runs a lesson module. Usage: mix run_lesson functions"

  @impl Mix.Task
  def run([x]) do
    case x do
      "functions" -> ElixirBasics.Lessons.Functions.run()
      "basics" -> ElixirBasics.Lessons.Basics.run()
      "control_flow" -> ElixirBasics.Lessons.ControlFlow.run()
      "collections" -> ElixirBasics.Lessons.Collections.run()
      "recursion_enum" -> ElixirBasics.Lessons.RecursionEnum.run()
      "structs" -> ElixirBasics.Lessons.Structs.run()
      "processes" -> ElixirBasics.Lessons.Processes.run()
      "genserver" -> ElixirBasics.Lessons.GenServerLesson.run()
      "supervisor" -> ElixirBasics.Lessons.SupervisorLesson.run()
      "tasks" -> ElixirBasics.Lessons.Tasks.run()
      "behaviours" -> ElixirBasics.Lessons.Behaviours.run()
      "application_otp" ->
        Mix.Task.run("app.start")
        ElixirBasics.Lessons.ApplicationOtp.run()
      "protocols" -> ElixirBasics.Lessons.Protocols.run()
      "ecto" -> ElixirBasics.Lessons.Ecto.run()
      _ -> Mix.shell().error("Unknown lesson. Available: basics, functions, control_flow, collections, recursion_enum, structs, processes, genserver, supervisor, tasks, behaviours, application_otp, protocols, ecto")
    end
  end
end
