defmodule Overpass do
  @moduledoc """
  """

  require Logger

  defmodule Tag do
    @moduledoc """
    http://wiki.openstreetmap.org/wiki/Tags
    """

    defstruct k: "", v: ""

    @type t :: %__MODULE__{
      k: String.t,
      v: String.t
    }
  end

  defmodule Node do
    @moduledoc """
    http://wiki.openstreetmap.org/wiki/Node
    """

    defstruct id: 0, lat: 0.0, lon: 0.0, tags: []

    @type t :: %__MODULE__{
      id:   integer,
      lat:  float,
      lon:  float,
      tags: [%Overpass.Tag{}]
    }
  end

  defmodule Way do
    @moduledoc """
    http://wiki.openstreetmap.org/wiki/Way
    """

    defstruct id: 0, nodes: [], tags: []

    @type t :: %__MODULE__{
      id:    integer,
      nodes: [%Overpass.Node{}],
      tags:  [%Overpass.Tag{}]
    }

    @doc """
    Returns a List of `%Overpass.Node{}` with all nodes from the selected way.
    Set `resolve_missing` to `true` to query the nodes from the API.
    """
    @spec get_nodes(%Way{}, [%Node{}], false | true) :: [%Node{}]
    def get_nodes(way, nodes, resolve_missing \\ false)

    def get_nodes(%Way{id: id, nodes: node_ids}, nodes, resolve_missing) when not resolve_missing do
      Logger.debug fn -> inspect(id) end
      Logger.debug fn -> inspect(node_ids) end
      Logger.debug fn -> inspect(resolve_missing) end
      Enum.filter(nodes, fn(%Node{id: node_id}) ->
        Enum.member?(node_ids, node_id)
      end)
    end

    def get_nodes(%Way{id: id, nodes: _node_ids}, _nodes, resolve_missing) when resolve_missing do
      Logger.debug fn -> inspect(id) end
      Logger.debug fn -> inspect(resolve_missing) end
      {:ok, %{nodes: nodes}} = Overpass.API.query("way(#{id});node(w);out body;")
                               |> Overpass.Parser.parse()
      nodes
    end
  end

  defmodule RelationMember do
    @moduledoc """
    http://wiki.openstreetmap.org/wiki/Relation
    """

    defstruct type: "", ref: "", role: ""

    @type t :: %__MODULE__{
      type: String.t,
      ref:  String.t,
      role: String.t,
    }
  end

  defmodule Relation do
    @moduledoc """
    http://wiki.openstreetmap.org/wiki/Relation
    """

    defstruct id: 0, members: [], tags: []

    @type t :: %__MODULE__{
      id:      integer,
      members: [%Overpass.RelationMember{}],
      tags:    [%Overpass.Tag{}]
    }
  end

  defmodule Response do
    @moduledoc """
    """
    defstruct nodes: [], ways: [], relations: []

    @type t :: %__MODULE__{
      nodes:     [%Overpass.Node{}],
      ways:      [%Overpass.Way{}],
      relations: [%Overpass.Relation{}]
    }
  end
end
