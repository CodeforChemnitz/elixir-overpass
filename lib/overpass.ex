defmodule Overpass do

    defmodule Tag do
        @doc """
        http://wiki.openstreetmap.org/wiki/Tags
        """
        defstruct k: "", v: ""
    end

    defmodule Node do
        @doc """
        http://wiki.openstreetmap.org/wiki/Node
        """
        defstruct id: "", lat: "", lon: "", tags: []
    end

    defmodule Way do
        @doc """
        http://wiki.openstreetmap.org/wiki/Way
        """
        defstruct id: "", node_ids: [], tags: []
    end

    defmodule Relation do
        @doc """
        http://wiki.openstreetmap.org/wiki/Relation
        """
        defstruct id: "", members: [], tags: []
    end

    defmodule RelationMember do
        @doc """
        http://wiki.openstreetmap.org/wiki/Relation
        """
        defstruct type: "", ref: "", role: ""
    end
end
