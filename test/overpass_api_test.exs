defmodule OverpassApiTest do
  use ExUnit.Case
  doctest OverpassApi
  require Logger
  import SweetXml

  # test "bad request" do
  #   result = OverpassApi.query_ql "bad"
  #   assert is_binary(result)
  # end

  # test "get ways as json" do
  #   result = OverpassApi.query_ql """
  #   way(50.746,7.154,50.748,7.157) ["highway"];
  #   (._;>;);
  #   out body;
  #   """, "json"
  #   assert {:ok, _} = result
  # end

  test "get ways as xml" do
    result = OverpassApi.query_ql """
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
