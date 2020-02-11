class FactStreamClient
  # Base url for all requests. We add '/graphql' to the end of it, so check your URL
  @@base_uri = Figaro.env.FACT_STREAM_BASE_URI

  # Empty initializer, since we're not using it now
  def initialize(); end

  # Get fact checks from fact stream, returns an array of *Claims*
  # +page+ and +count+ can be passed in for pagination purposes
  def fact_checks(page = 0, count = 50)
    # Get response
    response = request_from_fact_stream(page, count)
    # Parse the response
    parsed_response = parse_factstream_response response

    # Go through each fact_check and return an array of Claim objects from them
    parsed_response.map { |fact_check| claim_from_factstream_factcheck(fact_check) }.compact
  end

  # Go through all fact checks until FactStream stops responding,
  # or we find a fact check we've seen before
  # Set +continue+ to true to just ignore fact checks already saved here and continue
  def all_fact_checks(continue = false)
    # We just need to set some number to keep track of the loops and check status
    page = 0
    count = 50

    # Array we'll eventually return
    fact_checks = []

    # A continuous loop unles the response is empty (meaning FactStream has run out of stuff
    # to return) or, if +continue+ is false, if there's nils in the response (meaning it's
    # less than *count*)
    loop do
      print "Retrieving page ##{page}, #{fact_checks.count} fact checks so far...\n"
      # Get the fact checks for this loop
      begin
        next_fact_checks = fact_checks(page, count)
      rescue JSON::ParserError
        # If there's a parser error it means we hit the end.
        break
      end

      # If it's empty, let's just jump out
      break if next_fact_checks.empty?

      # Add everything to our running array
      fact_checks += next_fact_checks

      # If continue is false and there's not a full response, break out of the loop
      break if next_fact_checks.count < count && continue == false

      # Uh... loop stuff
      page += 1
    end

    # Returns the array
    fact_checks
  end

private

  # Creates a new *Claim* object from a +fact_check+ hash
  # Returns *nil* if the +fact_check+'s *id* is already assigned to a *Claim*'s *fact_stream_id*
  def claim_from_factstream_factcheck(fact_check)
    # Check if there's something that already has this FactStream id
    return unless Claim.find_by(fact_stream_id: fact_check["id"]).nil?

    # Create and return a new claim
    Claim.create(
      statement: fact_check["claim"],
      speaker_name: fact_check["speaker"],
      speaker_title: fact_check["speaker_title"],
      fact_stream_id: fact_check["id"],
      date: fact_check["created_at"],
      publisher_name: fact_check["publication"]
    )
  end

  # Send a request to FactStream and return the response (HTTPArty format)
  # +page+ and +count+ can be passed in for pagination purposes
  def request_from_fact_stream(page = 0, count = 50)
    query_string = graphql_query_string page, count

    request_headers = { "Content-Type": "application/json" }
    request_options = { body: query_string, headers: request_headers }

    begin
      HTTParty.post("#{@@base_uri}/graphql", request_options)
    rescue Exception
      # Edit this to capture only specific exceptions
    end
  end

  # Gets the query string for the GraphQL endpoint.
  # +page+ and +count+ can be passed in for pagination purposes
  def graphql_query_string(page = 0, count = 50)
    # GraphQL's syntax is odd. If you're not used to it Google is your friend
    # We pass this as the body though (note that the "query" JSON element followed by the string).
    query_string = <<~GRAPHQL
    {
      "query": "{
        factChecks(page: #{page}, count: #{count}) {
          id,
          claim:statement,
          speaker,
          speaker_title,
          created_at,
          publication
        }
      }"
    }
    GRAPHQL

    # Now we get rid of the new lines (they're here for easier formatting but they'll error out if
    # we send them.)
    query_string.delete!("\n")

    # Return the query string
    query_string
  end

  # Parse a +response+ from an HTTParty call to FactStream
  # Returns an array of fact check hashes
  def parse_factstream_response(response)
    # Parse the JSON string in the response body
    begin
      parsed_request = JSON.parse(response.body)
    rescue JSON::ParserError => e
      puts "Error parsing response from FactStream, request options: #{response.request.options}"
      raise e
    end

    # We make sure we have all the elements we need in the response.
    raise "Invalid response from FactStream" unless parsed_request.has_key? "data"
    data = parsed_request["data"]
    raise "No factChecks array in response from FactStream" unless data.has_key? "factChecks"
    fact_checks = data["factChecks"]
    # Return the parsed fact check array
    fact_checks
  end
end
