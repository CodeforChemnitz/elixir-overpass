defmodule OverpassApi do

  require Logger
  import SweetXml

  @url Application.get_env(:overpass, :url)


  def query_ql(query, format \\ "json")
  def query_ql(query, format) do
    Logger.debug "Query: #{query}"
    HTTPoison.post(@url, "[out:" <> format <> "];" <> query)
    |> process_call
    |> process_body
  end

  def process_call({:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers }}) do
    # content_type == "application/osm3s+xml"
    %{"Content-Type" => content_type} = Enum.into(headers, %{})
    Logger.debug "Content-Type! #{content_type}"
    {:ok, content_type, body}
  end

  def process_call({:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}}) do
    Logger.debug "Headers!"
    IO.inspect headers
    #IO.inspect body
    body
  end
  def process_call({:error, :connect_timeout}) do
    Logger.error "Woot! Timeout!"
    ""
  end
  def process_call({:ok, %HTTPoison.Response{status_code: 400}}) do
    Logger.error "Bad request!"
    ""
  end
  def process_call(whoot) do
    Logger.error "Was zur Hölle?"
    IO.inspect whoot
  end


  def process_body({:ok, content_type, body}) when content_type == "application/osm3s+xml" do
    Logger.debug "XML! #{body}"

    Logger.debug "WAYS:"
    ways = body |> xpath(~x"//way"l)
    Logger.debug fn -> inspect(ways) end

    Logger.debug "NODES:"
    nodes = body |> xpath(~x"//node"l)
    Logger.debug fn -> inspect(nodes) end

    {:ok, %{ways: ways, nodes: nodes}}
  end

  def process_body({:ok, content_type, body}) when content_type == "application/json" do
    Logger.debug "JSON! #{body}"
    decoded = Enum.into(:jsx.decode(body), %{})
    Logger.debug fn -> inspect(decoded) end
    {:ok, decoded}
  end

  def process_body({:ok, content_type, body}) do
    Logger.error "Content-Type #{content_type}"
    {:error, "unknown content-type"}
  end

end
