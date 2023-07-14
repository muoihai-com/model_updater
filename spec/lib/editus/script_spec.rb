require "rails_helper"

RSpec.describe Editus::Script do
  it do
    expect(Editus::Script.all).to eq({})
  end

  describe "DSL" do
    describe "#run" do
      it do
        Editus::Script::DSL.run(:test) do
          title "test"

          query :query_1 do
            return true
          end

          desc "Query Test"
          query :query_2 do
            return true
          end

          query :query_3 do
            return true
          end
        end
        internal = Editus::Script::Internal.find_or_create :test
        expect(internal.title).to eq("test")
        expect(internal.queries.first).to include({description: "Query#1",
                                                   query_name: "query_query_1"})
        expect(internal.queries.second).to include({description: "Query Test",
                                                    query_name: "query_query_2"})
        expect(internal.queries.third).to include({description: "Query#2",
                                                   query_name: "query_query_3"})
      end

      it do
        Editus::Script::DSL.run(:test_2) do
          title "test"
          desc "Query Test"
          query :query_1 do
            return true
          end

          desc "Query Test 2"
          query :query_2 do
            return true
          end

          query :query_3 do
            return true
          end
        end
        internal = Editus::Script::Internal.find_or_create :test_2
        expect(internal.title).to eq("test")
        expect(internal.queries).to eq(
          [
            {description: "Query Test", query_name: "query_query_1"},
            {description: "Query Test 2", query_name: "query_query_2"},
            {description: "Query#1", query_name: "query_query_3"}
          ]
        )
      end
    end
  end
end
