defmodule OverpassTest do
  use ExUnit.Case
  require Logger
  import SweetXml
  doctest Overpass

  test "Overpass JSON" do
      result = Overpass.API.query("node[\"name\"=\"Gielgen\"];out body;", "json")
      assert :jsx.is_json(result)
  end

  test "Overpass XML" do
      result = Overpass.API.query("node[\"name\"=\"Gielgen\"];out body;", "xml")
      assert is_binary(result)
  end

  test "get ways as xml" do
    result = Overpass.API.query """
    way(50.746,7.154,50.748,7.157) ["highway"];
    (._;>;);
    out body;
    """, "xml"
    assert {:ok, _} = result

    {:ok, %{ways: ways, nodes: nodes}} = result
    #OverpassHelper.get_attr_list ways, "lat"
    latlongs = nodes
    |> Stream.map(fn el -> { xpath(el, ~x"./@lat"s), xpath(el, ~x"./@lon"s) } end)
    |> Enum.into []
    assert is_list(latlongs)
    Logger.debug fn -> inspect(latlongs) end
  end

end
