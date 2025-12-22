defmodule PotionJobs.MCPServer do
  use Anubis.Server,
    name: "potion-jobs",
    version: "1.0.0",
    capabilities: [:tools]

  component PotionJobs.Resources.ElixirForumLastJobs
  component PotionJobs.Resources.ElixirForumJobDetails
end
