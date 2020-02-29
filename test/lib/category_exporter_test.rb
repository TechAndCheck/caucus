require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "Category exporter lists all availabe exporters" do
    assert CategoryExporter.available_exporters.count > 0
  end

  test "Category exporter can be created" do
    name = CategoryExporter.available_exporters.first
    exporter = CategoryExporter.new name
    assert_not_nil exporter
  end
end
