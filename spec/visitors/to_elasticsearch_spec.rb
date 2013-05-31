require 'spec_helper'

describe Apollo::Search::Visitors::ToElasticsearch do

  describe "Mapping Documents" do

    describe "Nodes::ObjectMapping" do
      it "should create a composite field" do
        mapping = Apollo::Search::Nodes::ObjectMapping.new("data_44")
        mapping << Apollo::Search::Nodes::DateMapping.new("some_date")
        mapping << Apollo::Search::Nodes::DateMapping.new("some_other_date")

        subject.accept(mapping).should == {
          "data_44" => { 
            "type" => "object", 
            "properties" => subject.accept(mapping.nodes.first).merge(subject.accept(mapping.nodes.last))
           }
        }
      end
    end

    describe "Nodes::DateMapping" do
      it "should create a date field" do
        mapping = Apollo::Search::Nodes::DateMapping.new("primitive")
        subject.accept(mapping).should == {
          "primitive" => { "type" => "date", "include_in_all" => false }
        }
      end
    end

    describe "Nodes::BooleanMapping" do
      it "should create a date field" do
        mapping = Apollo::Search::Nodes::BooleanMapping.new("primitive")
        subject.accept(mapping).should == {
          "primitive" => { "type" => "boolean", "include_in_all" => false }
        }
      end
    end

    describe "Nodes::StringMapping" do
      it "should create a date field" do
        mapping = Apollo::Search::Nodes::StringMapping.new("primitive")
        subject.accept(mapping).should == {
          "primitive" => { "type" => "string", "include_in_all" => false }
        }
      end
    end

    describe "Nodes::DoubleMapping" do
      it "should create a date field" do
        mapping = Apollo::Search::Nodes::DoubleMapping.new("primitive")
        subject.accept(mapping).should == {
          "primitive" => { "type" => "double", "include_in_all" => false }
        }
      end
    end

  end

  describe "Nodes::Match" do
    it "should constuct the correct match" do
      match = Apollo::Search::Nodes::Match.new("some_field", "Some value")

      subject.accept(match).should == {
        "match" => { "some_field" => "Some value" }
      }
    end
  end

  describe "Nodes::Prefix" do
    it "should constuct the correct structure" do
      match = Apollo::Search::Nodes::Prefix.new("some_field", "Some value")

      subject.accept(match).should == {
        "prefix" => { "some_field" => "Some value" }
      }
    end
  end

  describe "Nodes::Terms" do
    it "should constuct the correct structure" do
      match = Apollo::Search::Nodes::Terms.new("some_field", "Some value")

      subject.accept(match).should == {
        "terms" => { "some_field" => ["Some value"] }
      }
    end
  end

  describe "Nodes::Not" do
    it "should wrap with a not structure" do
      match = Apollo::Search::Nodes::Match.new("some_field", "Value")
      nt = Apollo::Search::Nodes::Not.new(match)

      result = subject.accept(nt)
      result.should have_key("not")
      result["not"].should be_instance_of(Hash)
    end
  end

  describe "Nodes::And" do
    it "should combine all nodes in an AND structure" do
      match1 = Apollo::Search::Nodes::Match.new("some_field", "Value")
      match2 = Apollo::Search::Nodes::Match.new("some_other_field", "Value")

      and_node = Apollo::Search::Nodes::And.new(match1, match2)
      result = subject.accept(and_node)
      result.should have_key("and")
      result["and"].should be_instance_of(Array)
      result["and"].each { |query| query.should be_instance_of(Hash) }
    end

    it "should not create the AND superstructure if only one node" do
      match1 = Apollo::Search::Nodes::Match.new("some_field", "value")
      and_node = Apollo::Search::Nodes::And.new(match1)
      result = subject.accept(and_node)
      result.should == subject.accept(match1)
    end

    it "should return a match_all if there aren't any nodes" do
      and_node = Apollo::Search::Nodes::And.new
      subject.accept(and_node).should == subject.accept(Apollo::Search::Nodes::MatchAll.new)
    end
  end

  describe "Nodes::Or" do
    it "should combine all nodes in an OR structure" do
      match1 = Apollo::Search::Nodes::Match.new("some_field", "Value")
      match2 = Apollo::Search::Nodes::Match.new("some_other_field", "Value")

      and_node = Apollo::Search::Nodes::Or.new(match1, match2)
      result = subject.accept(and_node)
      result.should have_key("or")
      result["or"].should be_instance_of(Array)
      result["or"].each { |query| query.should be_instance_of(Hash) }
    end
  end

  describe "Nodes::Exists" do
    it "should build the correct structure" do
      exists = Apollo::Search::Nodes::Exists.new("the_field")
      result = subject.accept(exists)
      result.should == {
        "exists" => {
          "field" => "the_field"
        }
      }
    end
  end

  describe "Nodes::Missing" do
    it "should build the correct structure" do
      node = Apollo::Search::Nodes::Missing.new("the_field")
      result = subject.accept(node)
      result.should == {
        "missing" => {
          "field" => "the_field",
          "existence" => true,
          "null_value" => true
        }
      }
    end

    it "should build the correct structure ignoring existence" do
      node = Apollo::Search::Nodes::Missing.new("the_field", false)
      result = subject.accept(node)
      result.should == {
        "missing" => {
          "field" => "the_field",
          "existence" => false,
          "null_value" => true
        }
      }
    end

    it "should build the correct structure ignoring nulls" do
      node = Apollo::Search::Nodes::Missing.new("the_field", true, false)
      result = subject.accept(node)
      result.should == {
        "missing" => {
          "field" => "the_field",
          "existence" => true,
          "null_value" => false
        }
      }
    end
  end

  describe "Nodes::Range" do
    it "should build a lower-only search" do
      range = Apollo::Search::Nodes::Range.new("some_field", 1, nil)

      result = subject.accept(range)
      result.should == {
        "range" => {
          "some_field" => {
            "from" => 1,
            "include_lower" => false
          }
        }
      }
    end

    it "should build a lower-only inclusive search" do
      range = Apollo::Search::Nodes::Range.new("some_field", 1, nil, true)

      result = subject.accept(range)
      result.should == {
        "range" => {
          "some_field" => {
            "from" => 1,
            "include_lower" => true
          }
        }
      }
    end

    it "should build a upper-only search" do
      range = Apollo::Search::Nodes::Range.new("some_field", nil, 1)

      result = subject.accept(range)
      result.should == {
        "range" => {
          "some_field" => {
            "to" => 1,
            "include_upper" => false
          }
        }
      }
    end

    it "should build a upper-only inclusive search" do
      range = Apollo::Search::Nodes::Range.new("some_field", nil, 1, false, true)

      result = subject.accept(range)
      result.should == {
        "range" => {
          "some_field" => {
            "to" => 1,
            "include_upper" => true
          }
        }
      }
    end

    it "should build a between search" do
      range = Apollo::Search::Nodes::Range.new("some_field", 0, 1)

      result = subject.accept(range)
      result.should == {
        "range" => {
          "some_field" => {
            "from" => 0,
            "to" => 1,
            "include_lower" => false,
            "include_upper" => false
          }
        }
      }
    end

    it "should build a between inclusive search" do
      range = Apollo::Search::Nodes::Range.new("some_field", 0, 1, true, true)

      result = subject.accept(range)
      result.should == {
        "range" => {
          "some_field" => {
            "from" => 0,
            "to" => 1,
            "include_lower" => true,
            "include_upper" => true
          }
        }
      }
    end
  end

  describe "Nodes::DateHistogramFacet" do
    it "should build the basic format" do
      facet = Apollo::Search::Nodes::DateHistogramFacet.new("some_date_field", "day")

      result = subject.accept(facet)
      result.should == {
        "date_histogram" => {
          "field" => "some_date_field",
          "interval" => "day"
        }
      }
    end

    it "should build the key/value format" do
      facet = Apollo::Search::Nodes::DateHistogramFacet.new("some_date_field", "week", value_field: "some_value_field")

      result = subject.accept(facet)
      result.should == {
        "date_histogram" => {
          "key_field" => "some_date_field",
          "value_field" => "some_value_field",
          "interval" => "week"
        }
      }
    end

    it "should include the timezone" do
      facet = Apollo::Search::Nodes::DateHistogramFacet.new("some_date_field", "month", time_zone: 5)

      result = subject.accept(facet)
      result.should == {
        "date_histogram" => {
          "field" => "some_date_field",
          "time_zone" => 5,
          "interval" => "month"
        }
      }
    end

    it "should include the filter" do
      filter = Apollo::Search::Nodes::Prefix.new("prefix_field", "value")
      facet = Apollo::Search::Nodes::DateHistogramFacet.new("some_date_field", "month", filter: filter)

      result = subject.accept(facet)
      result.should == {
        "date_histogram" => {
          "field" => "some_date_field",
          "interval" => "month",
          "facet_filter" => {
            "prefix" => {
              "prefix_field" => "value"
            }
          }
        }
      }
    end
  end

  describe "Nodes::HistogramFacet" do
    it "should build the basic format" do
      facet = Apollo::Search::Nodes::HistogramFacet.new("some_field", 100)

      result = subject.accept(facet)
      result.should == {
        "histogram" => {
          "field" => "some_field",
          "interval" => 100
        }
      }
    end

    it "should build the key/value format" do
      facet = Apollo::Search::Nodes::HistogramFacet.new("some_field", 200, value_field: "some_value")

      result = subject.accept(facet)
      result.should == {
        "histogram" => {
          "key_field" => "some_field",
          "value_field" => "some_value",
          "interval" => 200
        }
      }
    end

    it "should include use a time_interval if given" do
      facet = Apollo::Search::Nodes::HistogramFacet.new("some_date_field", "1.5h")

      result = subject.accept(facet)
      result.should == {
        "histogram" => {
          "field" => "some_date_field",
          "time_interval" => "1.5h"
        }
      }
    end

    it "should include the filter" do
      filter = Apollo::Search::Nodes::Prefix.new("prefix_field", "value")
      facet = Apollo::Search::Nodes::HistogramFacet.new("some_field", 500, filter: filter)

      result = subject.accept(facet)
      result.should == {
        "histogram" => {
          "field" => "some_field",
          "interval" => 500,
          "facet_filter" => {
            "prefix" => {
              "prefix_field" => "value"
            }
          }
        }
      }
    end
  end

  describe "Nodes::TermsFacet" do
    it "shoud build the basic format" do
      facet = Apollo::Search::Nodes::TermsFacet.new("the_field")
      result = subject.accept(facet)
      result.should == {
        "terms" => {
          "field" => "the_field"
        }
      }
    end

    it "should include the order" do
      facet = Apollo::Search::Nodes::TermsFacet.new("the_field", order: "term")
      result = subject.accept(facet)
      result.should == {
        "terms" => { 
          "field" => "the_field",
          "order" => "term"
        }
      }
    end

    it "should include the size" do
      facet = Apollo::Search::Nodes::TermsFacet.new("the_field", size: 20)
      result = subject.accept(facet)
      result.should == {
        "terms" => {
          "field" => "the_field",
          "size" => 20
        }
      }
    end

    it "should include the filter" do
      filter = Apollo::Search::Nodes::Prefix.new("prefix_field", "value")
      facet = Apollo::Search::Nodes::TermsFacet.new("the_field", filter: filter)

      result = subject.accept(facet)
      result.should == {
        "terms" => {
          "field" => "the_field",
          "facet_filter" => {
            "prefix" => {
              "prefix_field" => "value"
            }
          }
        }
      }
    end

  end

  describe "Nodes::GeoDistanceFacet" do
    it "should build the basic format" do
      facet = Apollo::Search::Nodes::GeoDistanceFacet.new("pin.location", 10, -20)

      result = subject.accept(facet)
      result.should == {
        "geo_distance" => {
          "pin.location" => {
            "lat" => 10,
            "long" => -20
          }
        }
      }
    end

    it "should build the key/value structure" do
      facet = Apollo::Search::Nodes::GeoDistanceFacet.new("pin.location", 10, -20, value_field: "cost")

      result = subject.accept(facet)
      result.should == {
        "geo_distance" => {
          "pin.location" => {
            "lat" => 10,
            "long" => -20
          },
          "value_field" => "cost"
        }
      }
    end

    it "should include the ranges" do
      range1 = Apollo::Search::Nodes::RangeFacetRange.new(nil, 200)
      range2 = Apollo::Search::Nodes::RangeFacetRange.new(150, 210)
      range3 = Apollo::Search::Nodes::RangeFacetRange.new(300, nil)

      facet = Apollo::Search::Nodes::GeoDistanceFacet.new("the_field", 30, 20, ranges: [range1, range2, range3])
      result = subject.accept(facet)
      result.should == {
        "geo_distance" => {
          "the_field" => {
            "lat" => 30,
            "long" => 20
          },
          "ranges" => [
            { "to" => 200 },
            { "from" => 150, "to" => 210 },
            { "from" => 300 }
          ]
        }
      }
    end

    it "should include the filter" do
      filter = Apollo::Search::Nodes::Prefix.new("prefix_field", "value")
      facet = Apollo::Search::Nodes::GeoDistanceFacet.new("pin.location", 1.34, 5.44, filter: filter)

      result = subject.accept(facet)
      result.should == {
        "geo_distance" => {
          "pin.location" => {
            "lat" => 1.34,
            "long" => 5.44
          },
          "facet_filter" => {
            "prefix" => {
              "prefix_field" => "value"
            }
          }
        }
      }
    end

  end

  describe "Nodes::TermsStatsFacet" do
    it "shoud build the basic format" do
      facet = Apollo::Search::Nodes::TermsStatsFacet.new("the_field", "value")
      result = subject.accept(facet)
      result.should == {
        "terms_stats" => {
          "key_field" => "the_field",
          "value_field" => "value"
        }
      }
    end

    it "should include the order" do
      facet = Apollo::Search::Nodes::TermsStatsFacet.new("the_field", "value", order: "term")
      result = subject.accept(facet)
      result.should == {
        "terms_stats" => { 
          "key_field" => "the_field",
          "value_field" => "value",
          "order" => "term"
        }
      }
    end

    it "should include the size" do
      facet = Apollo::Search::Nodes::TermsStatsFacet.new("the_field", "value", size: 20)
      result = subject.accept(facet)
      result.should == {
        "terms_stats" => {
          "key_field" => "the_field",
          "value_field" => "value",
          "size" => 20
        }
      }
    end

    it "should include the filter" do
      filter = Apollo::Search::Nodes::Prefix.new("prefix_field", "value")
      facet = Apollo::Search::Nodes::TermsStatsFacet.new("the_field", "some_value", filter: filter)

      result = subject.accept(facet)
      result.should == {
        "terms_stats" => {
          "key_field" => "the_field",
          "value_field" => "some_value",
          "facet_filter" => {
            "prefix" => {
              "prefix_field" => "value"
            }
          }
        }
      }
    end

  end

  describe "Nodes::StatisticalFacet" do
    it "shoud build the basic format" do
      facet = Apollo::Search::Nodes::StatisticalFacet.new("the_field")
      result = subject.accept(facet)
      result.should == {
        "statistical" => {
          "field" => "the_field"
        }
      }
    end

    it "should include the filter" do
      filter = Apollo::Search::Nodes::Prefix.new("prefix_field", "value")
      facet = Apollo::Search::Nodes::StatisticalFacet.new("the_field", filter: filter)

      result = subject.accept(facet)
      result.should == {
        "statistical" => {
          "field" => "the_field",
          "facet_filter" => {
            "prefix" => {
              "prefix_field" => "value"
            }
          }
        }
      }
    end

  end

  describe "Nodes::RangeFacet" do
    it "shoud build the basic format" do
      range1 = Apollo::Search::Nodes::RangeFacetRange.new(nil, 200)
      range2 = Apollo::Search::Nodes::RangeFacetRange.new(150, 210)
      range3 = Apollo::Search::Nodes::RangeFacetRange.new(300, nil)
      facet = Apollo::Search::Nodes::RangeFacet.new("the_field", [range1, range2, range3])

      result = subject.accept(facet)
      result.should == {
        "range" => {
          "field" => "the_field",
          "ranges" => [
            { "to" => 200 },
            { "from" => 150, "to" => 210 },
            { "from" => 300 }
          ]
        }
      }
    end

    it "should include the filter" do
      filter = Apollo::Search::Nodes::Prefix.new("prefix_field", "value")
      range1 = Apollo::Search::Nodes::RangeFacetRange.new(nil, 200)
      range2 = Apollo::Search::Nodes::RangeFacetRange.new(150, 210)
      range3 = Apollo::Search::Nodes::RangeFacetRange.new(300, nil)
      facet = Apollo::Search::Nodes::RangeFacet.new("the_field", [range1, range2, range3], filter: filter)

      result = subject.accept(facet)
      result.should == {
        "range" => {
          "field" => "the_field",
          "ranges" => [
            { "to" => 200 },
            { "from" => 150, "to" => 210 },
            { "from" => 300 }
          ],
          "facet_filter" => {
            "prefix" => {
              "prefix_field" => "value"
            }
          }
        }
      }
    end

  end

  describe "Nodes::NamedFacet" do
    it "should have the correct structure" do
      facet = Apollo::Search::Nodes::TermsFacet.new("field")
      named = Apollo::Search::Nodes::NamedFacet.new("some_name", facet)

      result = subject.accept(named)
      facet_result = subject.accept(facet)

      result.should == {
        "some_name" => facet_result
      }
    end
  end

  describe "Nodes::FacetList" do
    it "should have the correct structure" do
      list = Apollo::Search::Nodes::FacetList.new
      
      facet = Apollo::Search::Nodes::TermsFacet.new("field")
      named = Apollo::Search::Nodes::NamedFacet.new("some_name", facet)
      named2 = Apollo::Search::Nodes::NamedFacet.new("some_name_other", facet)

      list << named
      list << named2

      result = subject.accept(list)

      result.should have_key("some_name")
      result.should have_key("some_name_other")

      result["some_name"].should == subject.accept(facet)
      result["some_name_other"].should == subject.accept(facet)
    end
  end

end