defmodule Overpass.Parser do
    require Logger
    import SweetXml

    @doc """
    Parses the OverpassAPI query xml response.
    Returns a tuple `{:ok, %{nodes: nodes, ways: ways, relations: relations}}` on success or `{:error, error}` on error.
    """
    def parse({:ok, {:xml , response}}) do
        Logger.debug("Type: xml")
        osm = response |> xpath(~x"//osm")
        nodes = osm
        |> xpath(~x"./node"l)
        |> Enum.map fn (node) ->
            %Overpass.Node{
                id: node |> xpath(~x"./@id"i),
                lat: node |> xpath(~x"./@lat"s),
                lon: node |> xpath(~x"./@lon"s),
                tags: node |> xpath(~x"./tag"l) |> Enum.map(
                    fn (tag) -> %Overpass.Tag{
                        k: tag |> xpath(~x"./@k"s),
                        v: tag |> xpath(~x"./@v"s)
                    }
                    end
                )
            }
        end

        ways = osm
        |> xpath(~x"./way"l)
        |> Enum.map fn (way) ->
            %Overpass.Way{
                id: way |> xpath(~x"./@id"i),
                node_ids: way |> xpath(~x"./nd"l) |> Enum.map(
                    fn (nd) -> nd |> xpath(~x"./@ref"i) end
                ),
                tags: way |> xpath(~x"./tag"l) |> Enum.map(
                    fn (tag) -> %Overpass.Tag{
                        k: tag |> xpath(~x"./@k"s),
                        v: tag |> xpath(~x"./@v"s)
                    }
                    end
                )
            }
        end

        relations = osm
        |> xpath(~x"./relation"l)
        |> Enum.map fn (relation) ->
            %Overpass.Relation{
                id: relation |> xpath(~x"./@id"i),
                members: relation |> xpath(~x"./member"l) |> Enum.map(
                    fn (member) -> %Overpass.RelationMember{
                        type: member |> xpath(~x"./@type"s),
                        ref: member |> xpath(~x"./@ref"i),
                        role: member |> xpath(~x"./@role"s)
                    }
                    end
                ),
                tags: relation |> xpath(~x"./tag"l) |> Enum.map(
                    fn (tag) -> %Overpass.Tag{
                        k: tag |> xpath(~x"./@k"s),
                        v: tag |> xpath(~x"./@v"s)
                    }
                    end
                )
            }
        end

        Logger.debug fn -> inspect(nodes) end
        Logger.debug fn -> inspect(ways) end
        Logger.debug fn -> inspect(relations) end
        {:ok, %{nodes: nodes, ways: ways, relations: relations}}
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
