class CsvBinaryMlExporter < Exporter
  attr_reader :headers, :objects

  def initialize(**args)
    @categories = args[:categories]

    raise "Categories must be provided for exporting" if @categories.nil?

    headers = ["claim", "id"]
    headers.concat(@categories.collect { |c| c.name })

    args[:headers] = headers
    args[:objects] = args[:claims] unless args[:claims].nil?
    super
  end

  def process
    # We go through first and make a lookup hash, since it's faster than an index search
    category_look_up = generate_lookup_hash @categories

    csv_string = CSV.generate do |csv|
      # Add all the titles
      csv << @headers.values unless @headers.nil?

      # Go through each claim, create an array big enough with 0, pull the categories, lookup the index, and insert 1
      @objects.each do |object|
        binary_array = create_binary_array(object, @categories, category_look_up)
        csv << [object.statement, object.id].concat(binary_array)
      end unless @objects.nil?
    end

    csv_string
  end

private

  def generate_lookup_hash(categories)
    category_look_up = {}
    categories.each_with_index { |c, i| category_look_up[c.name] = i }
    category_look_up
  end

  def create_binary_array(object, categories, category_look_up)
    categories_array = Array.new categories.count, 0

    object.categories.each do |category|
      index = category_look_up[category.name]
      categories_array[index] = 1
    end

    categories_array
  end
end
