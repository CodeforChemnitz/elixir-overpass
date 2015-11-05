defmodule Overpass do
    require Logger

    @url Application.get_env(:overpass, :url)

    def query(query) do
        #Logger.debug("Query: #{query}")
        HTTPoison.post(@url, query)
        |> process_response
        |> process_body
    end

    defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}}) do
        #Logger.debug("Response Body: #{body}")
        %{"Content-Type" => content_type} = Enum.into(headers, %{})
        {:ok, content_type, body}
    end

    defp process_response({:ok, %HTTPoison.Response{status_code: 400, body: _body, headers: _headers}}) do
        Logger.error("Bad Request")
        {:error, "Bad Request"}
    end

    defp process_response({:error, error}) do
        Logger.error(error)
        {:error, error}
    end

    defp process_body({:ok, content_type, body}) when content_type == "application/osm3s+xml" do
        #Logger.debug(body)
        body
    end

    defp process_body({:ok, content_type, body}) when content_type == "application/json" do
        #Logger.debug(body)
        body
    end

    defp process_body({:ok, _content_type, _body}) do
        #Logger.debug("Unsuported Content-Type")
        ""
    end

    defp process_body({:error, error}) do
        Logger.error(error)
        {:error, error}
    end

end
