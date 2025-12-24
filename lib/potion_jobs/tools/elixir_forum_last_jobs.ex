defmodule PotionJobs.Tools.ElixirForumLastJobs do
  @moduledoc """
  MCP tool for fetching the latest Elixir job listings from Elixir Forum.

  This tool retrieves the most recent job postings from the "Elixir Jobs" category
  on Elixir Forum, which is the primary community resource for Elixir developer job listings.

  ## Response Format

  Returns a JSON object with a "topics" key containing an array of job listings:

  ```json
  {
    "topics": [
      {
        "id": 12345,
        "title": "Senior Elixir Developer - Remote",
        "created_at": "2024-01-15T10:30:00.000Z",
        "tags": ["remote", "senior", "full-time"]
      }
    ]
  }
  ```

  ## Filtering

  The tool automatically filters out the "elixir-jobs-section-info" topic which
  is not an actual job posting but a category description.

  ## External API

  This tool fetches data from:
  `https://elixirforum.com/c/work/elixir-jobs/16.json`

  ## Usage

  This tool requires no parameters and can be invoked directly to get
  the latest job listings.
  """

  use Anubis.Server.Component, type: :tool
  alias Anubis.Server.Response

  @elixir_jobs_category_url "https://elixirforum.com/c/work/elixir-jobs/16.json"
  @topic_url "https://elixirforum.com/t/:topic_id.json"

  @type topic :: %{
          optional(String.t()) => term()
        }

  schema do
  end

  @spec execute(map(), map()) :: {:reply, map(), map()}
  def execute(_params, frame) do
    topics = get_last_topics!()
    {:reply, Response.json(Response.tool(), %{"topics" => topics}), frame}
  end

  @spec get_last_topics!() :: [topic()]
  def get_last_topics! do
    %Req.Response{status: 200, body: %{"topic_list" => %{"topics" => topics}}} =
      Req.get!(@elixir_jobs_category_url)

    for topic <- topics, topic["slug"] != "elixir-jobs-section-info" do
      Map.take(topic, ["tags", "title", "id", "created_at"])
    end
  end

  @doc """
  Fetches raw job offer details for a specific topic.

  This is a helper function that retrieves the full topic data from Elixir Forum.
  Note: This is a low-level function that returns the raw response.

  ## Parameters
    * `topic_id` - The ID of the topic to fetch

  ## Returns
    The raw Req.Response from the Elixir Forum API
  """
  @spec get_job_offer_details(pos_integer()) :: Req.Response.t()
  def get_job_offer_details(topic_id) do
    Req.get!(@topic_url, path_params: [topic_id: topic_id])
  end
end
