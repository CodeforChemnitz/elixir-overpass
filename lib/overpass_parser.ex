defmodule Overpass.Parser do
    require Logger
    import SweetXml

    @doc """
    Parses the OverpassAPI query response.
    Returns a tuple `{:ok, %{ways: ways, nodes: nodes}}` on success or `{:error, error}` on error.
    """
    def parse({:ok, {:xml , response}}) do
        Logger.debug("Type: xml")
        Logger.debug "WAYS:"
        ways = response |> xpath(~x"//way"l)
        Logger.debug fn -> inspect(ways) end

        Logger.debug "NODES:"
        nodes = response |> xpath(~x"//node"l)
        Logger.debug fn -> inspect(nodes) end

        {:ok, %{ways: ways, nodes: nodes}}
    end

    def parse({:ok, {:json, response}}) do
        Logger.debug("Type: json")
        {:ok, ""}
    end

    def parse({:error, error}) do
        Logger.error(error)
        {:error, error}
    end

end
