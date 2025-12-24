defmodule PotionJobs.Tools.ElixirForumJobDetails do
  @moduledoc """
  MCP tool for fetching detailed information about a specific Elixir job posting.

  This tool retrieves full details of a job offer from Elixir Forum, including
  the job description, author information, posting date, and any responses
  or comments on the posting.

  ## Parameters

  * `topic_id` (integer, required) - The ID of the job posting topic

  ## Response Format

  On success, returns a JSON object with the following structure:

  ```json
  {
    "id": 12345,
    "title": "Senior Elixir Developer - Remote",
    "author": "company_name",
    "created_at": "2024-01-15T10:30:00.000Z",
    "job_description": "<p>Full job description in HTML format...</p>",
    "responses": [
      "<p>Response from candidate...</p>"
    ]
  }
  ```

  On error, returns:

  ```json
  {
    "error": "Error message describing what went wrong"
  }
  ```

  ## Error Handling

  The tool handles various error scenarios:
  * HTTP non-200 responses - Returns the status code and response body
  * Network/request errors - Returns a generic error message

  ## External API

  This tool fetches data from:
  `https://elixirforum.com/t/:topic_id.json`

  ## Usage

  First, use `elixir_forum_last_jobs` to get a list of job postings with their IDs.
  Then, use this tool with a specific `topic_id` to get the full details of a
  job posting that interests you.
  """

  use Anubis.Server.Component, type: :tool

  alias Anubis.Server.Response
  require Logger

  @topic_url "https://elixirforum.com/t/:topic_id.json"

  @type job_offer :: %{
          optional(String.t() | atom()) => term()
        }

  @type error_response :: %{
          optional(String.t() | atom()) => term()
        }

  schema do
    field(:topic_id, :integer, required: true)
  end

  @spec execute(%{topic_id: pos_integer()}, map()) :: {:reply, map(), map()}
  def execute(params, frame) do
    Logger.info("Params received in ElixirForumJobDetails #{inspect(params)}")
    topic_id = params.topic_id
    job_offer = get_job_offer_details(topic_id)
    {:reply, Response.json(Response.tool(), job_offer), frame}
  end

  @spec get_job_offer_details(pos_integer()) :: job_offer() | error_response()
  def get_job_offer_details(topic_id) do
    request = Req.new(url: @topic_url, path_params: [topic_id: topic_id])
    Logger.debug("Request: #{inspect(request)}")

    case Req.get(request) do
      {:ok, %Req.Response{status: 200, body: data}} ->
        %{
          author: data["details"]["created_by"]["username"],
          job_description: data["post_stream"]["posts"] |> List.first() |> Map.get("cooked"),
          title: data["title"],
          id: data["id"],
          created_at: data["created_at"],
          responses:
            data["post_stream"]["posts"]
            |> Enum.drop(1)
            |> Enum.map(&Map.get(&1, "cooked"))
        }

      {:ok, %Req.Response{status: status, body: body}} ->
        Logger.error(
          "Failed to fetch job offer details for topic_id #{topic_id}. HTTP status: #{status}. Body: #{inspect(body)}"
        )

        %{
          error:
            "Failed to fetch job offer details. HTTP status: #{status}. Body: #{inspect(body)}"
        }

      {:error, err} ->
        %{error: "Request error: #{inspect(err)}"}
    end
  end
end
