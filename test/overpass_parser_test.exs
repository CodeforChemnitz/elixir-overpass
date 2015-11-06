defmodule OverpassParserTest do
  use ExUnit.Case
  doctest Overpass.Parser

  test "Overpass.Parser Error" do
      assert {:error, _} = Overpass.API.query("FooBar") |> Overpass.Parser.parse
  end

  test "Overpass.Parser with JSON" do
      assert {:ok, _} = Overpass.API.query("[out:json];node[\"name\"=\"Gielgen\"];out 5;") |> Overpass.Parser.parse
  end

  test "Overpass.Parser with XML" do
      assert {:ok, %{nodes: _nodes, ways: _ways, relations: _relations }} = Overpass.API.query("""
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
  end
end
