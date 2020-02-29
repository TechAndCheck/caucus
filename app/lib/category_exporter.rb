class CategoryExporter
  def self.available_exporters
    files = Dir[File.join(".", "app/exporters/**/*.rb")].map do |f|
      require f
      f
    end

    get_exporters_names files
  end

  def initialize(exporter_class, **args)
    clazz = exporter_class.constantize
    @exporter = clazz.new

    @args = args
  end

  def process
    @exporter.process(@args)
  end

private

  def self.get_exporters_names(files)
    files.map do |file|
      name = File.basename(file, ".rb").camelize
      name == "Exporter" ? nil : name
    end.compact
  end
end
