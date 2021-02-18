class CsvBinaryMlExporter < Exporter
  attr_reader :headers, :objects

  def initialize(**args)
    @categories = args[:categories]

    raise "Categories must be provided for exporting" if @categories.nil?

    headers = ["claim"]
    headers.concat(@categories.collect { |c| c.name })

    args[:headers] = headers
    args[:objects] = args[:claims] unless args[:claims].nil?
    super
  end

  def process(response, headers, totals: false)
    headers["Content-Type"] = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"full_report.csv\""

    # streaming_headers
    # nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'
    headers["Cache-Control"] ||= "no-cache"

    # Rack::ETag 2.2.x no longer respects 'Cache-Control'
    # https://github.com/rack/rack/commit/0371c69a0850e1b21448df96698e2926359f17fe#diff-1bc61e69628f29acd74010b83f44d041
    headers["Last-Modified"] = Time.current.httpdate

    headers.delete("Content-Length")
    response.status = 200

    csv_header = @headers.values unless @headers.nil?
    csv_options = { col_sep: ";" }

    category_look_up = generate_lookup_hash @categories

    csv_enumerator = Enumerator.new do |y|
      y << CSV::Row.new(csv_header, csv_header, true).to_s(csv_options) unless @headers.nil?
      categories_count = @categories.count
      @objects.find_each do |object|
        binary_array = create_binary_array(object, categories_count, category_look_up)
        y << CSV::Row.new(csv_header, [object.statement].concat(binary_array)).to_s(csv_options)
      end unless @objects.nil?

      if totals == true
        category_totals = @categories.map { |category| category.claims.count }
        y << CSV::Row.new(csv_header,["Total: "].concat(category_totals)).to_s(csv_options)
      end
    end

    # setting the body to an enumerator, rails will iterate this enumerator
    { headers: headers, response: response, enumerator: csv_enumerator }
  end

private

  def generate_lookup_hash(categories)
    category_look_up = {}
    categories.each_with_index { |c, i| category_look_up[c.name] = i }
    category_look_up
  end

  def create_binary_array(object, categories_count, category_look_up)
    categories_array = Array.new categories_count, 0
    object.categories.each do |category|
      index = category_look_up[category.name]
      next if index.nil?

      categories_array[index] = 1
    end

    categories_array
  end
end
