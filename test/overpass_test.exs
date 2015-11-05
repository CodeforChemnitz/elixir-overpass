defmodule OverpassTest do
  use ExUnit.Case
  doctest Overpass

  test "Overpass JSON" do
      result = Overpass.query("[out:json];node[\"name\"=\"Gielgen\"];out body;")
      assert :jsx.is_json(result)
  end

  test "Overpass XML" do
      result = Overpass.query("[out:xml];node[\"name\"=\"Gielgen\"];out body;")
      assert is_binary(result)
  end

end
