defmodule PotionJobs.Resources.ElixirForumLastJobs do
  @moduledoc """
  Resource fetching the last job offers from Elixir Forum

  Developer job offers (for Elixir developers) are posted in the "Elixir Jobs" category of Elixir Forum.
  """
  use Anubis.Server.Component, type: :tool
  alias Anubis.Server.Response

  @elixir_jobs_category_url "https://elixirforum.com/c/work/elixir-jobs/16.json"
  @topic_url "https://elixirforum.com/t/:topic_id.json"

  schema do
  end

  def execute(_params, frame) do
    topics = get_last_topics!()
    {:reply, Response.json(Response.tool(), %{"topics" => topics}), frame}
  end

  def get_last_topics! do
    %Req.Response{status: 200, body: %{"topic_list" => %{"topics" => topics}}} =
      Req.get!(@elixir_jobs_category_url)

    for topic <- topics, topic["slug"] != "elixir-jobs-section-info" do
      Map.take(topic, ["tags", "title", "id", "created_at"])
    end
  end

  def get_job_offer_details(topic_id) do
    Req.get!(@topic_url, path_params: [topic_id: topic_id])
  end
end
