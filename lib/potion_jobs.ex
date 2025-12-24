defmodule PotionJobs do
  @moduledoc """
  PotionJobs - MCP server for Elixir job listings.

  This application provides tools for fetching and searching Elixir developer
  job opportunities from the Elixir Forum's "Elixir Jobs" category.

  ## Architecture

  The application is structured as an OTP application with the following components:

  - `PotionJobs.Application` - Supervises the application's children
  - `PotionJobs.Router` - HTTP router with MCP endpoint
  - `PotionJobs.MCPServer` - MCP server configuration and tool registry
  - `PotionJobs.Tools.ElixirForumLastJobs` - Tool for fetching latest job listings
  - `PotionJobs.Tools.ElixirForumJobDetails` - Tool for fetching job details

  The server exposes MCP tools through the Anubis framework, allowing AI assistants
  to interact with Elixir Forum's job listings.
  """
end
