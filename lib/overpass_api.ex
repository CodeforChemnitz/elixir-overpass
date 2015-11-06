defmodule Overpass.API do

    require Logger

    @url Application.get_env(:overpass, :url)

    @doc ~S"""
    Querys the OverpassAPI with the given query.
    Returns a tuple `{:ok, {:xml, body}}` or `{:ok, {:json, body}}` on success or `{:error, error}` on error.

    ## Example

        iex> Overpass.API.query("[out:json];node[\"name\"=\"Gielgen\"];out 2;")
        {:ok, {:json, json}}

        iex> Overpass.API.query("[out:xml];node[\"name\"=\"Gielgen\"];out 2;")
        {:ok, {:xml, xml}}


    """
    def query(query) do
        Logger.debug("Query: #{query}")
        HTTPoison.post(@url, query)
        |> process_response
    end

    defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}}) do
        Logger.debug("status_code: 200")
        %{"Content-Type" => content_type} = Enum.into(headers, %{})
        case content_type do
            "application/osm3s+xml" -> {:ok, {:xml, body}}
            "application/json" -> {:ok, {:json, body}}
            _ -> {:error, "Unsuported Content-Type"}
        end
    end

    defp process_response({:ok, %HTTPoison.Response{status_code: code, body: _body, headers: _headers}}) do
        Logger.error("status_code: #{code}")
        {:error, "status_code: #{code}"}
    end

    defp process_response({:error, error}) do
        Logger.error(error)
        {:error, error}
    end
end
