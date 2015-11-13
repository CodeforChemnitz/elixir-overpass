defmodule OverpassParserTest do
    use ExUnit.Case
    doctest Overpass.Parser

    test "Overpass.Parser Error" do
        assert {:error, _} = Overpass.API.query("FooBar") |> Overpass.Parser.parse
    end

    test "Overpass.Parser with JSON | Node" do
        assert {:ok, %Overpass.Response{
            nodes: _nodes,
            ways: _ways,
            relations: _relations
        }} = Overpass.API.query("""
            [out:json];
            node(50.746,7.154,50.748,7.157);
            out body;
        """) |> Overpass.Parser.parse
    end

    test "Overpass.Parser with JSON | Way" do
        assert {:ok, %Overpass.Response{
            nodes: _nodes,
            ways: _ways,
            relations: _relations
        }} = Overpass.API.query("""
            [out:json];
            way(50.746,7.154,50.748,7.157);
            out body;
        """) |> Overpass.Parser.parse
    end

    test "Overpass.Parser with JSON | Relation" do
        assert {:ok, %Overpass.Response{
            nodes: _nodes,
            ways: _ways,
            relations: _relations
        }} = Overpass.API.query("""
            [out:json];
            relation(50.746,7.154,50.748,7.157);
            out body;
        """) |> Overpass.Parser.parse
    end

    test "Overpass.Parser with XML | Node" do
        assert {:ok, %Overpass.Response{
            nodes: _nodes,
            ways: _ways,
            relations: _relations
        }} = Overpass.API.query("""
            node(50.746,7.154,50.748,7.157);
            out body;
        """) |> Overpass.Parser.parse
    end

    test "Overpass.Parser with XML | Way" do
        assert {:ok, %Overpass.Response{
            nodes: _nodes,
            ways: _ways,
            relations: _relations
        }} = Overpass.API.query("""
            way(50.746,7.154,50.748,7.157);
            out body;
        """) |> Overpass.Parser.parse
    end

    test "Overpass.Parser with XML | Relation" do
        assert {:ok, %Overpass.Response{
            nodes: _nodes,
            ways: _ways,
            relations: _relations
        }} = Overpass.API.query("""
            relation(50.746,7.154,50.748,7.157);
            out body;
        """) |> Overpass.Parser.parse
    end

end
