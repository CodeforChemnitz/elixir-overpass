defmodule OverpassParserTest do
  use ExUnit.Case
  doctest Overpass.Parser

  test "Overpass.Parser Error" do
      assert {:error, _} = Overpass.API.query("FooBar") |> Overpass.Parser.parse
  end

  test "Overpass.Parser with JSON" do
      assert {:ok, _} = Overpass.API.query("[out:json];node[\"name\"=\"Gielgen\"];out 2;") |> Overpass.Parser.parse
  end

  test "Overpass.Parser with XML" do
      assert {:ok, %{ways: ways, nodes: nodes}} = Overpass.API.query("[out:xml];node[\"name\"=\"Gielgen\"];out 2;") |> Overpass.Parser.parse
      assert is_list(ways)
      assert is_list(nodes)
  end
end
