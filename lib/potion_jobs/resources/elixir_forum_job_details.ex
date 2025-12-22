defmodule PotionJobs.Resources.ElixirForumJobDetails do
  @moduledoc """
  Resource fetching the details of a specific job offer from Elixir Forum

  Developer job offers (for Elixir developers) are posted in the "Elixir Jobs" category of Elixir Forum.
  """
  use Anubis.Server.Component, type: :tool

  alias Anubis.Server.Response
  require Logger

  @topic_url "https://elixirforum.com/t/:topic_id.json"

  schema do
    field(:topic_id, :integer, required: true)
  end

  def execute(params, frame) do
    IO.inspect(params, label: "Params received in ElixirForumJobDetails")
    topic_id = params.topic_id
    job_offer = get_job_offer_details(topic_id)
    {:reply, Response.json(Response.tool(), job_offer), frame}
  end

  def get_job_offer_details(topic_id) do
    request = Req.new(url: @topic_url, path_params: [topic_id: topic_id])
    IO.inspect(request, pretty: true, label: "PREVIEW")

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
