require "test_helper"

class SimpleCsvExporterTest < ActiveSupport::TestCase
  test "CSV Binary ML Exporter can be created" do
    exporter = CsvBinaryMlExporter.new({ categories: Category.all })
    assert_not_nil exporter
  end

  test "CSV Binary ML Exporter can be created with an array of claims and categories" do
    exporter = CsvBinaryMlExporter.new({ claims: [claims(:one), claims(:two)], categories: Category.all })
    assert_not_nil exporter

    exporter.process

    assert_equal 2, exporter.objects.count
    assert_equal({ "claim": "claim", "id": "id", "Category 1": "Category 1", "Category 2": "Category 2" }, exporter.headers)
  end

  test "CSV Binary ML Exporter can export headers with categoris" do
    exporter = CsvBinaryMlExporter.new({ categories: Category.all })
    assert_equal "claim,id,Category 1,Category 2\n", exporter.process
  end

  test "CSV Binary ML Exporter can export headers and objects" do
    exporter = CsvBinaryMlExporter.new({ claims: [claims(:one), claims(:two)], categories: Category.all })
    expected = "claim,id,Category 1,Category 2\n"\
               "Test Claim 1,980190962,1,1\n"\
               "Test Claim 2,298486374,1,0\n"
    assert_equal expected, exporter.process
  end
end
