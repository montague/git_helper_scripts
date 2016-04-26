defmodule GitIntegrate do
  require System

  @integration_file ".integration_branches.json"

  def main(args) do
    base_branch = "develop"
    integration_branch_name = "integration-branch-#{:erlang.system_time}"
    branches = File.read!(@integration_file)
            |> Poison.Parser.parse!
            |> Map.get("branches")
    create_integration_branch(base_branch, integration_branch_name)
    Enum.each(branches, &merge_branch/1)
    IO.puts "Created integration branch: #{integration_branch_name}"
  end

  def check_exit_status({output, exit_status}) do
    if exit_status !== 0 do
      exit({:shutdown, exit_status})
    end
    {output, exit_status}
  end

  def create_integration_branch(base_branch_name, integration_branch_name) do
    git_cmd(~w(checkout #{base_branch_name}))
    git_cmd(~w(checkout -b #{integration_branch_name}))
  end

  def git_cmd(cmds) do
    System.cmd("git", cmds) |> check_exit_status
  end

  def merge_branch(branch_to_merge) do
    git_cmd(~w(merge #{branch_to_merge}))
  end
end
