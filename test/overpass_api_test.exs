defmodule OverpassAPITest do
  use ExUnit.Case
  doctest Overpass.API

  test "Overpass.API Error" do
      result = Overpass.API.query("FooBar")
      assert {:error, _} = result
  end

  test "Overpass.API with JSON" do
      {:ok, {:json, result}} = Overpass.API.query("[out:json];node[\"name\"=\"Gielgen\"];out 2;")
      {:ok, %HTTPoison.Response{status_code: _code, body: body, headers: _headers}} = HTTPoison.get("http://overpass.osm.rambler.ru/cgi/interpreter?data=%5Bout:json%5D;node%5Bname%3DGielgen%5D%3Bout%202%3B")
      assert result == body
  end

  test "Overpass.API with XML" do
      {:ok, {:xml, result}} = Overpass.API.query("[out:xml];node[\"name\"=\"Gielgen\"];out 2;")
      {:ok, %HTTPoison.Response{status_code: _code, body: body, headers: _headers}} = HTTPoison.get("http://overpass.osm.rambler.ru/cgi/interpreter?data=node%5Bname%3DGielgen%5D%3Bout%202%3B")
      assert result == body
  end
end
