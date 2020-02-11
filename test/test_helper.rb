# SimpleCov let's us measure how much test coverage we have
require "simplecov"
SimpleCov.start "rails"
# Branch coverage lets us track branch conditions i.e. number.odd? ? true : false
# details: https://github.com/colszowka/simplecov#branch-coverage-ruby--25
# SimpleCov.enable_coverage :branch

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers

  # SimpleCov doesn't work with parallelize (https://github.com/colszowka/simplecov/issues/718)
  # parallelize(workers: :number_of_processors)
  parallelize(workers: 1)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
