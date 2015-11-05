defmodule OverpassApiTest do
  use ExUnit.Case
  doctest OverpassApi

  # test "bad request" do
  #   result = OverpassApi.query_ql "bad"
  #   assert is_binary(result)
  # end

  test "get ways as json" do
    result = OverpassApi.query_ql """
    [out:json];
    way(50.746,7.154,50.748,7.157) ["highway"];
    (._;>;);
    out body;
    """
    assert is_binary(result)
  end

  # test "get ways as xml" do
  #   result = OverpassApi.query_ql """
  #   [out:xml];
  #   way(50.746,7.154,50.748,7.157) ["highway"];
  #   (._;>;);
  #   out body;
  #   """
  #   assert is_binary(result)
  # end

end
