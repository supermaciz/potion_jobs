defmodule PotionJobs.Tools.ElixirJobsOfferDetails do
  @moduledoc """
  MCP tool to fetch offer details from elixirjobs.net.


  ## Parameters
  - `link` (string, required): The URL of the offer details page.
  """
  use Anubis.Server.Component, type: :tool
  require Logger
  alias Anubis.Server.Response
  import Meeseeks.XPath

  schema do
    field(:link, :string, required: true)
  end

  @impl true
  def execute(params, frame) do
    link = params[:link]

    response =
      case get_offer_details(link) do
        {:ok, body} ->
          %{body: body}

        {:error, error} ->
          %{error: inspect(error)}
      end

    {:reply, Response.json(Response.tool(), response), frame}
  end

  def get_offer_details(link) do
    case Req.get(link) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        parse_offer_details(body)

      {:ok, %Req.Response{status: status, body: body}} ->
        Logger.error("Failed to fetch offer details: status #{status} (#{inspect(body)})")
        {:error, "Failed to fetch offer details"}

      {:error, error} ->
        Logger.error("Failed to fetch offer details: #{inspect(error)}")
        {:error, "Failed to fetch offer details"}
    end
  end

  defp parse_offer_details(body) do
    with document when is_struct(document, Meeseeks.Document) <- Meeseeks.parse(body),
         {:ok, job_title} <-
           Meeseeks.fetch_one(document, xpath("/html/body/section/section/div/div[1]/div[1]/h2")),
         {:ok, company_location} <-
           Meeseeks.fetch_one(document, xpath("/html/body/section/section/div/div[1]/div[1]/h3")),
         {:ok, workplace} <-
           Meeseeks.fetch_one(
             document,
             xpath("/html/body/section/section/div/div[1]/div[2]/div/div[1]/span[2]")
           ),
         {:ok, description} <-
           Meeseeks.fetch_one(document, xpath("/html/body/section/section/div/div[2]")),
         {:ok, external_link} <-
           Meeseeks.fetch_one(document, xpath("/html/body/section/section/div/nav/p/a")) do
      {:ok,
       %{
         job_title: Meeseeks.text(job_title),
         company_location: Meeseeks.text(company_location),
         workplace: Meeseeks.text(workplace),
         description: Meeseeks.text(description),
         external_link: Meeseeks.attr(external_link, "href")
       }}
    end
  end
end
