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
        defstruct id: "", lat: "", lon: "", attributes: %{}, tags: []
    end

    defmodule Way do
        @doc """
        http://wiki.openstreetmap.org/wiki/Way
        """
        defstruct nds: [], tags: []
    end

    defmodule Relation do
        @doc """
        http://wiki.openstreetmap.org/wiki/Relation
        """
        defstruct members: [], tags: []
    end

    defmodule RelationMember do
        @doc """
        http://wiki.openstreetmap.org/wiki/Relation
        """
        defstruct typ: "", ref: "", role: ""
    end
end
