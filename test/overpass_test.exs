defmodule OverpassTest do
  use ExUnit.Case
  require Logger
  doctest Overpass

  test "Overpass 400er" do
      result = Overpass.API.query("foobar")
      assert {:error, _} = result
  end

  test "Overpass JSON" do
      {:ok, result} = Overpass.API.query("node[\"name\"=\"Gielgen\"];out 2;", "json")
      {:ok, %HTTPoison.Response{status_code: _code, body: body, headers: _headers}} = HTTPoison.get("http://overpass.osm.rambler.ru/cgi/interpreter?data=%5Bout:json%5D;node%5Bname%3DGielgen%5D%3Bout%202%3B")
      assert result == body
  end

  test "Overpass XML" do
      {:ok, result} = Overpass.API.query("node[\"name\"=\"Gielgen\"];out 2;", "xml")
      {:ok, %HTTPoison.Response{status_code: _code, body: body, headers: _headers}} = HTTPoison.get("http://overpass.osm.rambler.ru/cgi/interpreter?data=node%5Bname%3DGielgen%5D%3Bout%202%3B")
      assert result == body
  end

end
