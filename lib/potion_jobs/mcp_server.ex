defmodule PotionJobs.MCPServer do
  @moduledoc """
  MCP (Model Context Protocol) Server for PotionJobs.

  This module defines the MCP server configuration and registers available tools
  that can be invoked by MCP clients (AI assistants).
  """

  @version Application.spec(:potion_jobs)[:vsn] |> to_string()

  use Anubis.Server,
    name: "potion-jobs",
    version: @version,
    capabilities: [:tools]

  component(PotionJobs.Tools.ElixirForumLastJobs)
  component(PotionJobs.Tools.ElixirForumJobDetails)
end
