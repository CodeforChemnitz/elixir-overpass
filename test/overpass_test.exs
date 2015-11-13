defmodule OverpassTest do
    use ExUnit.Case
    require Logger
    doctest Overpass

    test "Overpass.Way.get_nodes() JSON" do
        {:ok, %Overpass.Response{
            nodes: nodes,
            ways: ways
        }} = Overpass.API.query("""
            [out:"json"];
            (
              node
                ["amenity"="fire_station"]
                (50.6,7.0,50.8,7.3);
              way
                ["amenity"="fire_station"]
                (50.6,7.0,50.8,7.3);
              rel
                ["amenity"="fire_station"]
                (50.6,7.0,50.8,7.3);
            );
            (._;>;);
            out;
        """) |> Overpass.Parser.parse

        test_with_false = Overpass.Way.get_nodes(List.first(ways), nodes)
        test_with_true = Overpass.Way.get_nodes(List.first(ways), [], true)

        Logger.debug("test_with_false")
        Logger.debug fn -> inspect(test_with_false) end
        assert is_list(test_with_false)
        Logger.debug("test_with_true")
        Logger.debug fn -> inspect(test_with_true) end
        assert is_list(test_with_true)
    end

    test "Overpass.Way.get_nodes() XML" do
        {:ok, %Overpass.Response{
            nodes: nodes,
            ways: ways
        }} = Overpass.API.query("""
            (
              node
                ["amenity"="fire_station"]
                (50.6,7.0,50.8,7.3);
              way
                ["amenity"="fire_station"]
                (50.6,7.0,50.8,7.3);
              rel
                ["amenity"="fire_station"]
                (50.6,7.0,50.8,7.3);
            );
            (._;>;);
            out;
        """) |> Overpass.Parser.parse

        test_with_false = Overpass.Way.get_nodes(List.first(ways), nodes)
        test_with_true = Overpass.Way.get_nodes(List.first(ways), [], true)

        Logger.debug("test_with_false")
        Logger.debug fn -> inspect(test_with_false) end
        assert is_list(test_with_false)
        Logger.debug("test_with_true")
        Logger.debug fn -> inspect(test_with_true) end
        assert is_list(test_with_true)
    end

end
