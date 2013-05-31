# Aqua

A Query Algebra

Inspired from the Arel project, Aqua attempts be the framework's framework for connecting to and working with searching.

Currently only ElasticSearch is supported.

**Note that this is a work in progress! Contributions welcome!**

## Installation

Add this line to your application's Gemfile:

    gem 'aqua'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aqua

## Usage

Currently Aqua supports the following operations:

* Index creation, deletion, and flushing.
* Mapping creation, and updating.
* Document creation, updating and deletion.

### Querying

All queries in Aqua are handled through the `Aqua::QueryManager` class. For example, to query a document for containing the text "Find Me" with the created_at between Jan 2012 and Dec 2012:

    query = Aqua::QueryManager.new
    query.query << Aqua::Nodes::Text.new("description", "Find Me")
    query.query << Aqua::Nodes::Range.new("created_at", Time.gm(2012, 1, 1), Time.gm(2012, 12, 31), true, true)
    query.to_elastic_search

    => {"query"=>{"filtered"=>{"query"=>{"and"=>[{"text"=>{"description"=>"Find Me"}}, {"range"=>{"created_at"=>{"from"=>2012-01-01 00:00:00 UTC, "to"=>2012-12-31 00:00:00 UTC, "include_lower"=>true, "include_upper"=>true}}}]}}}, "sort"=>[]}

## Todo

Oh so much!

* Drop the hardcoded filtered query in favour of a FilteredQuery node.
* Support Queries: multi_match, boosting, ids, custom_score, custom_boost_factor, constant_score, dis_max, field, filtered, flt, flt_field, fuzzy, has_child, has_parent, mlt, mlt_field, regexp, span*, common, top_children, wildcard, nested, custom_filters_score, indicies, geo_shape.
* Support Filters: geo*, has_child, has_parent, numeric_range, regexp, script, nested.
* Work out a better way to handle setting mapping properties such as analyzed.
* Support Mapping Types: geo*, attachment, nested

... and more!

## Difficulties

One of the difficulties I'm expecting to encounter is that there's no language standard between the search implementations (like there is with SQL), so I'm just planning on tackling this project one engine at a time.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
