defmodule Overpass.Parser do
    @moduledoc """
    """

    require Logger
    import SweetXml

    @doc """
    Parses the OverpassAPI query response.
    Returns a tuple `{:ok, %{nodes: nodes, ways: ways, relations: relations}}`.
    """
    def parse({:ok, {:xml , response}}) do
        Logger.debug("Type: xml")
        osm = response |> xpath(~x"//osm")
        nodes = osm
        |> xpath(~x"./node"l)
        |> Enum.map fn (node) ->
            %Overpass.Node{
                id: node |> xpath(~x"./@id"i),
                lat: node |> xpath(~x"./@lat"s) |> String.to_float(),
                lon: node |> xpath(~x"./@lon"s) |> String.to_float(),
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
                nodes: way |> xpath(~x"./nd"l) |> Enum.map(
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
        {:ok, %Overpass.Response{nodes: nodes, ways: ways, relations: relations}}
    end

    def parse({:ok, {:json, response}}) do
        Logger.debug("Type: json")
        %{"elements" => elements} = Enum.into(:jsx.decode(response), %{})
        elems = elements
        |> Enum.map(
            fn (node) ->
                node |> Enum.into(%{})
            end
        )

        nodes = elems
        |> Enum.filter(
            fn %{"type" => type} ->
                type == "node"
            end
        )
        |> Enum.map(
            fn (node) ->
                node |> map_node()
            end
        )

        ways = elems
        |> Enum.filter(
            fn %{"type" => type} ->
                type == "way"
            end
        )
        |> Enum.map(
            fn (way) ->
                way |> map_way()
            end
        )

        relations = elems
        |> Enum.filter(
            fn %{"type" => type} ->
                type == "relation"
            end
        )
        |> Enum.map(
            fn (relation) ->
                relation |> map_relation()
            end
        )

        Logger.debug fn -> inspect(nodes) end
        Logger.debug fn -> inspect(ways) end
        Logger.debug fn -> inspect(relations) end
        {:ok, %Overpass.Response{nodes: nodes, ways: ways, relations: relations}}
    end

    def parse({:error, error}) do
        Logger.error(error)
        {:error, error}
    end

    defp map_tag({key, value}) do
        %Overpass.Tag{k: key, v: value}
    end

    defp map_node(%{"id" => id, "lon" => lon, "lat" => lat, "tags" => tags}) do
        %Overpass.Node{
            id: id,
            lon: lon,
            lat: lat,
            tags: tags |> Enum.map(fn (tag) -> tag |> map_tag() end)
        }
    end

    defp map_node(%{"id" => id, "lon" => lon, "lat" => lat}) do
        %Overpass.Node{
            id: id,
            lon: lon,
            lat: lat,
            tags: []
        }
    end

    defp map_way(%{"id" => id, "nodes" => nodes, "tags" => tags}) do
        %Overpass.Way{
            id: id,
            nodes: nodes,
            tags: tags |> Enum.map(fn (tag) -> tag |> map_tag() end)
        }
    end

    defp map_way(%{"id" => id, "nodes" => nodes}) do
        %Overpass.Way{
            id: id,
            nodes: nodes,
            tags: []
        }
    end

    defp map_relation_member(%{"type" => type, "ref" => ref, "role" => role}) do
        %Overpass.RelationMember{
            type: type,
            ref: ref,
            role: role
        }
    end

    defp map_relation(%{"id" => id, "members" => members, "tags" => tags}) do
        %Overpass.Relation{
            id: id,
            members: members |> Enum.map(fn (member) -> member |> Enum.into(%{}) |> map_relation_member() end),
            tags: tags |> Enum.map(fn (tag) -> tag |> map_tag() end)
        }
    end

    defp map_relation(%{"id" => id, "members" => members}) do
        %Overpass.Relation{
            id: id,
            members: members |> Enum.map(fn (member) -> member |> map_relation_member() end),
            tags: []
        }
    end
end
