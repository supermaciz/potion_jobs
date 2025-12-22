defmodule PotionJobs.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  forward "/mcp",
    to: Anubis.Server.Transport.StreamableHTTP.Plug,
    init_opts: [server: PotionJobs.MCPServer]

  match _ do
    send_resp(conn, 404, "oops")
  end
end
