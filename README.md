# Elixir-Overpass

A Elixir wrapper to access the Overpass API.

Have a look at the [documentation](http://codeforchemnitz.de/elixir-overpass/doc/) to find additional information.

Based on https://github.com/DinoTools/python-overpy http://python-overpy.readthedocs.org/

## Features

* [x] Query Overpass API
* [x] Parse JSON and XML response data
* [ ] Additional helper functions


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add overpass to your list of dependencies in `mix.exs`:

        def deps do
          [{:overpass, "~> 0.1.0"}]
        end

  2. Ensure overpass is started before your application:

        def application do
          [applications: [:overpass]]
        end

## Examples

### Query the API

Using QL:
```
{:ok, {:xml, response}} = Overpass.API.query("""
  node["name"="Gielgen"];
  out body;
""")
```

```
{:ok, {:json, response}} = Overpass.API.query("""
  [out:json];
  node["name"="Gielgen"];
  out body;
""")
```

Using XML:
```
{:ok, {:xml, response}} = Overpass.API.query("""
  <osm-script>
    <query type="node">
      <has-kv k="name" v="Gielgen"/>
    </query>
    <print/>
  </osm-script>
""")
```

```
{:ok, {:json, response}} = Overpass.API.query("""
  <osm-script output="json">
    <query type="node">
      <has-kv k="name" v="Gielgen"/>
    </query>
    <print/>
  </osm-script>
""")
```

### Query the API and Parse the Result

```
{:ok, %Overpass.Response{nodes: nodes, ways: ways, relations: relations}} = Overpass.API.query("""
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
""") |> Overpass.Parser.parse()
```

### Get the nodes for a way

```
{:ok, %Overpass.Response{nodes: nodes, ways: ways, relations: _relations}} = Overpass.API.query("""
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
""") |> Overpass.Parser.parse()

# Get nodes for the way from the responded nodes
list_with_nodes = Overpass.Way.get_nodes(nodes, List.first(ways))

# Get all nodes for the way (new Overpass.Query)
list_with_nodes = Overpass.Way.get_nodes(nodes, List.first(ways), true)
```

## Helper

TODO

# License

The MIT License (MIT)
