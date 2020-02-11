require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "FactStream import works for one page" do
    fact_checks = FactStreamClient.new.fact_checks
    assert_same 50, fact_checks.count, "FactStream should return 50 new claims"
  end

  test "FactStream import works for multiple pages" do
    # So, to stop our loop from going on forever, we'll look at the third page, so it'll stop then
    fact_stream_client = FactStreamClient.new
    fact_stream_client.fact_checks(3, 50)

    fact_checks = fact_stream_client.all_fact_checks
    assert_same 150, fact_checks.count, "FactStreamClient should have checked more than one page"
  end

  test "FactStream import for multiple pages should keep going if something's already in the database" do
    # We hack this, so that it 1. get 30 at some point, which should normally stop it, and instead it keeps going
    # Since we'll make sure it gets an empty response eventually it'll stop since it'll assume we're at the end.
    fact_stream_client = FactStreamClient.new
    fact_stream_client.fact_checks(3, 20)
    fact_stream_client.fact_checks(5, 50)

    fact_checks = fact_stream_client.all_fact_checks(true)
    assert_same 230, fact_checks.count, "FactStreamClient should have continued"
  end

  test "FactStream breaks at the end" do
    # FactStream returns a 500 if it can't find anything, this pulls an arbitarily large page to make sure
    fact_stream_client = FactStreamClient.new
    assert_raises(JSON::ParserError) do
      fact_stream_client.fact_checks(5000, 50)
    end
  end
end
