class SimpleCsvExporter < Exporter
  attr_reader :headers, :objects

  def process
    csv_string = CSV.generate do |csv|
      # Add all the titles
      csv << @headers.values unless @headers.nil?

      @objects.each do |object|
        csv << @headers.keys.map do |k|
          if k == "categories" || k == :categories
            object.categories.map { |c| c.name }.join(",")
          else
            object[k].to_s
          end
        end
      end unless @objects.nil?
    end

    csv_string
  end
end
