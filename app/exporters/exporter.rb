class Exporter
  def initialize(**args)
    @headers = args[:headers]
    @objects = args[:objects]
    # headers can be an array of keys, or a hash in the formate {key: title} (if you want the exported title to be named differently than the key is)
    @headers = Hash[@headers.collect { |item| [item.to_sym, item] } ] if @headers.class == Array
  end

  def process
    raise NoMethodError.new "Please define `process` in any subclass of Exporter"
  end
end
