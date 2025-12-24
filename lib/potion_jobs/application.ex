defmodule PotionJobs.Application do
  @moduledoc """
  The OTP application supervisor for PotionJobs.

  This module defines the supervision tree for the PotionJobs application.

  ## Children

  The application supervises the following children:

  * `Bandit` - HTTP server that handles incoming HTTP requests
  * `Anubis.Server.Registry` - Registry for MCP server components
  * `PotionJobs.MCPServer` - The main MCP server instance with streamable HTTP transport

  ## Configuration

  The application uses a `one_for_one` supervision strategy, meaning that if a child
  process terminates, only that process is restarted.

  ## See also

  * https://hexdocs.pm/elixir/Application.html
  * https://hexdocs.pm/elixir/Supervisor.html
  """

  use Application

  @impl true
  @spec start(term(), term()) :: {:ok, pid()} | {:error, term()}
  def start(_type, _args) do
    children = [
      {Bandit, plug: PotionJobs.Router},
      Anubis.Server.Registry,
      {PotionJobs.MCPServer, transport: :streamable_http}
    ]

    opts = [strategy: :one_for_one, name: PotionJobs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
