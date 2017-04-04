defmodule OverpassAPITest do
  use ExUnit.Case
  doctest Overpass.API

  test "Overpass.API Error" do
    assert {:error, _} = Overpass.API.query("FooBar")
  end

  test "Overpass.API with QL and JSON-Response" do
    assert {:ok, {:json, _}} = Overpass.API.query(
                                                  ~s([out:json];node["name"="Gielgen"];out 2;)
                                                )
  end

  test "Overpass.API with QL and XML-Response" do
    assert {:ok, {:xml, _}} = Overpass.API.query(
                                                 ~s([out:xml];node[\"name\"=\"Gielgen\"];out 2;)
                                               )
  end
end
