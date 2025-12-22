defmodule PotionJobs.MCPServer do
  use Anubis.Server,
    name: "potion-jobs",
    version: "1.0.0",
    capabilities: [:tools]

  component PotionJobs.Tools.ElixirForumLastJobs
  component PotionJobs.Tools.ElixirForumJobDetails
end
