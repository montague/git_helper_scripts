defmodule GitIntegrate do
  require System

  @integration_file ".integration_branches.json"

  def main(_args) do
    base = "develop"
    integration = get_integration_branch
    create_integration_branch(base, integration)
    get_branches |> merge_branches
    IO.puts "Built integration branch: #{integration}"
  end

  def get_integration_branch do
    suffix = :erlang.system_time
              |> to_string
              |> String.slice(-6..-1)
    "integration-branch-#{suffix}"
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
