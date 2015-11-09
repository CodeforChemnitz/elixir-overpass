defmodule Overpass do
    @moduledoc """
    ToDo: Documentation
    """
    require Logger

    defmodule Response do
        @moduledoc """
        ToDo: Documentation
        """

        @doc """
        ToDo: Documentation
        """
        defstruct nodes: [], ways: [], relations: []
    end

    defmodule Tag do
        @moduledoc """
        ToDo: Documentation
        """

        @doc """
        http://wiki.openstreetmap.org/wiki/Tags
        ToDo: Documentation
        """
        defstruct k: "", v: ""
    end

    defmodule Node do
        @moduledoc """
        ToDo: Documentation
        """

        @doc """
        http://wiki.openstreetmap.org/wiki/Node
        ToDo: Documentation
        """
        defstruct id: "", lat: "", lon: "", tags: []
    end

    defmodule Way do
        @moduledoc """
        ToDo: Documentation
        """

        @doc """
        http://wiki.openstreetmap.org/wiki/Way
        ToDo: Documentation
        """
        defstruct id: "", nodes: [], tags: []

        @doc """
        Returns a List of `%Overpass.Node{}` whith all nodes from the selected way.
        Set `resolve_missing` to `true` to query the nodes from the API.
        """
        def get_nodes(nodes, way, resolve_missing \\ false)

        def get_nodes(nodes, %Way{id: id, nodes: node_ids}, resolve_missing) when not resolve_missing do
            Logger.debug fn -> inspect(id) end
            Logger.debug fn -> inspect(node_ids) end
            Logger.debug fn -> inspect(resolve_missing) end
            Enum.filter(nodes,
                fn %Node{id: node_id} ->
                    Enum.member?(node_ids, node_id)
                end
            )
        end

        def get_nodes(_nodes, %Way{id: id, nodes: _node_ids}, resolve_missing) when resolve_missing do
            Logger.debug fn -> inspect(id) end
            Logger.debug fn -> inspect(resolve_missing) end
            {:ok, %Response{nodes: nodes}} = Overpass.API.query("""
                way(#{id});node(w);out body;
            """) |> Overpass.Parser.parse()
            nodes
        end
    end

    defmodule Relation do
        @moduledoc """
        ToDo: Documentation
        """

        @doc """
        http://wiki.openstreetmap.org/wiki/Relation
        ToDo: Documentation
        """
        defstruct id: "", members: [], tags: []
    end

    defmodule RelationMember do
        @moduledoc """
        ToDo: Documentation
        """

        @doc """
        http://wiki.openstreetmap.org/wiki/Relation
        ToDo: Documentation
        """
        defstruct type: "", ref: "", role: ""
    end
end
