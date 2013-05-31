require 'spec_helper'

describe Apollo::Search::Index do
  subject { Apollo::Search::Index.new("test_index") }

  before do
    Apollo::Search.connection = connection
  end

  let(:connection) do
    mock("connection")
  end

  describe "#create" do
    it "should issue a create statement" do
      connection.should_receive(:execute).with(instance_of(Apollo::Search::Nodes::CreateIndexStatement)).and_return(true)
      subject.create
    end
  end

  describe "#store" do
    it "should issue a document statement" do
      connection.should_receive(:execute).with(instance_of(Apollo::Search::Nodes::DocumentStatement)).and_return("one-id")
      subject.store_document(_id: "one-id", key: "value")
    end
  end

  describe "#query" do
    it "should return a QueryScope" do
      result = subject.query("type")
      result.should be_a(Apollo::Search::QueryScope)
      result.types.should == ["type"]
    end
  end
end
