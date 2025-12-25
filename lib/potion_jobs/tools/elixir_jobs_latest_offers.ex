defmodule PotionJobs.Tools.ElixirJobsLatestOffers do
  @moduledoc """
  MCP tool for fetching the latest Elixir job oofers from elixirjobs.net
  """

  use Anubis.Server.Component, type: :tool
  alias Anubis.Server.Response

  # No params
  schema do
  end

  def execute(_params, frame) do
    case get_latest_offers() do
      {:ok, offers} ->
        {:reply, Response.json(Response.tool(), %{"offers" => offers}), frame}

      {:error, reason} ->
        {:reply,
         Response.json(Response.tool(), %{"error" => "Failed to fetch latest offers: #{reason}"}),
         frame}
    end
  end

  def get_latest_offers do
    with {:ok, %Req.Response{status: 200, body: data}} <- Req.get("https://elixirjobs.net/rss"),
         {:ok, parsed_rss} <- FastRSS.parse_rss(data) do
      offers =
        Enum.map(parsed_rss["items"], fn item ->
          %{
            title: item["title"],
            link: item["link"],
            date: item["pubDate"],
            description: item["description"]
          }
        end)

      {:ok, offers}
    end
  end
end
