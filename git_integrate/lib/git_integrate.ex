defmodule GitIntegrate do
  require System

  @integration_file ".integration_branches.json"

  def main(_args) do
    base = "develop"
    create_integration_branch(base, "i")
    get_branches |> merge_branches
    IO.puts "Built integration branch"
  end

  def create_integration_branch(base, integration) do
    git_cmd(~w(checkout #{base}))
    git_cmd(~w(checkout -b #{integration}))
  end

  def get_branches do
    File.read!(@integration_file)
    |> Poison.Parser.parse!
    |> Map.get("branches")
  end

  def git_cmd(cmds) do
    System.cmd("git", cmds) |> check_exit_status
  end

  def merge_branches(branches) do
    Enum.each(branches, fn branch ->
      git_cmd(~w(merge #{branch}))
    end)
  end

  def check_exit_status({output, exit_status}) do
    if exit_status !== 0 do
      exit({:shutdown, exit_status})
    end
    {output, exit_status}
  end
end
