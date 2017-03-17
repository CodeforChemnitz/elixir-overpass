defmodule Overpass.API do
  @moduledoc """
  Provides the functions to query the Overpass API.

  Don't forget to add the following to your `config/config.exs`:
  ```
  config :overpass, url: "http://overpass-api.de/api/interpreter"
  ```
  """

  require Logger

  @url Application.get_env(:overpass, :url)

  @doc """
  Querys the OverpassAPI with the given query (xml or overpass ql).
  Returns a tuple `{:ok, {:xml, body}}` or `{:ok, {:json, body}}` on success
  or `{:error, error}` on error.
  """
  @spec query(String.t) :: {:ok, {:json, String.t}}
  @spec query(String.t) :: {:ok, {:xml, String.t}}
  @spec query(String.t) :: {:error, String.t}
  def query(query) do
    Logger.debug("Query: #{query}")
    HTTPoison.post(@url, query) |> process_response()
  end

  defp process_response({
    :ok,
    %HTTPoison.Response{
      status_code: 200,
      body: body,
      headers: headers}
      }) do
      Logger.debug("status_code: 200")
      %{"Content-Type" => content_type} = Enum.into(headers, %{})
      case content_type do
        "application/osm3s+xml" -> {:ok, {:xml, body}}
        "application/json" -> {:ok, {:json, body}}
        _ -> {:error, "Unsuported Content-Type"}
      end
      end

      defp process_response({
        :ok,
        %HTTPoison.Response{
        status_code: code,
        body: _body,
        headers: _headers}
      }) do
    Logger.error("status_code: #{code}")
    {:error, "status_code: #{code}"}
      end

      defp process_response({:error, error}) do
        Logger.error(error)
        {:error, error}
      end
end
