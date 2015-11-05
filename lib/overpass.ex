defmodule Overpass do

    @url Application.get_env(:overpass, :url)

    def query(query) do
        HTTPoisen.post
    end
end
