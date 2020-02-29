require "test_helper"

class SimpleCsvExporterTest < ActiveSupport::TestCase
  test "Simple Csv Exporter can be created" do
    exporter = SimpleCsvExporter.new
    assert_not_nil exporter
  end

  test "Simple Csv Exporter can be created with an array of headers" do
    exporter = SimpleCsvExporter.new({ headers: ["test", "one", "two"] })
    assert_not_nil exporter

    assert_equal 3, exporter.headers.count
    assert_equal({ "test": "test", "one": "one", "two": "two" }, exporter.headers)
  end

  test "Simple Csv Exporter can be created with a hash of headers" do
    exporter = SimpleCsvExporter.new({ headers: { test: "help1", one: "help2", two: "help3" } })
    assert_not_nil exporter
    assert_equal({ test: "help1", one: "help2", two: "help3" }, exporter.headers)
  end

  test "Simple Csv Exporter can export headers" do
    exporter = SimpleCsvExporter.new({ headers: { test: "help1", one: "help2", two: "help3" } })
    assert_equal "help1,help2,help3\n", exporter.process
  end

  test "Simple Csv Exporter can export headers and objects" do
    exporter = SimpleCsvExporter.new({
      headers: [
        "statement",
        "speaker_name",
        "speaker_title",
        "categories"
      ],
      objects: [
        claims(:one),
      ]
    })
    expected = "statement,speaker_name,speaker_title,categories\n"\
               "Test Claim 1,Person 1,Person's Title 1,\"Category 1,Category 2\"\n"
    assert_equal expected, exporter.process
  end
end
