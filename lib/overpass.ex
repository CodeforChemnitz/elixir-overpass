defmodule Overpass do

    defmodule API do

        require Logger
        import SweetXml

        @url Application.get_env(:overpass, :url)

        def query(query, format \\ "json")
        def query(query, format) do
            query = "[out:" <> format <> "];" <> query
            Logger.debug("Query: #{query}")
            HTTPoison.post(@url, query)
            |> process_response
            |> process_body
        end

        defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}}) do
            Logger.debug("status_code: 200")
            %{"Content-Type" => content_type} = Enum.into(headers, %{})
            {:ok, content_type, body}
        end

        defp process_response({:ok, %HTTPoison.Response{status_code: code, body: _body, headers: _headers}}) do
            Logger.error("status_code: #{code}")
            {:error, "status_code: #{code}"}
        end

        defp process_response({:error, error}) do
            Logger.error(error)
            {:error, error}
        end

        defp process_body({:ok, content_type, body}) when content_type == "application/osm3s+xml" do
            Logger.debug("application/osm3s+xml")
            Logger.debug "WAYS:"
            ways = body |> xpath(~x"//way"l)
            Logger.debug fn -> inspect(ways) end

            Logger.debug "NODES:"
            nodes = body |> xpath(~x"//node"l)
            Logger.debug fn -> inspect(nodes) end

            {:ok, %{ways: ways, nodes: nodes}}
        end

        defp process_body({:ok, content_type, body}) when content_type == "application/json" do
            Logger.debug("application/json")
            body
        end

        defp process_body({:ok, _content_type, _body}) do
            Logger.error("Unsuported Content-Type")
            {:error, "Unsuported Content-Type"}
        end

        defp process_body({:error, error}) do
            Logger.error(error)
            {:error, error}
        end
    end
end
