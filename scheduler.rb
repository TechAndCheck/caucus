require File.expand_path("config/boot",        __dir__)
require File.expand_path("config/environment", __dir__)
require "clockwork"

# Schedules the checking for factchecks. Adjust the time here.
module Clockwork
  # Error handler staying for future purposes if we add more jobs.
  every(1.hour, "FactStream Import") do
    ScheduledTasks::FactStream::Import.perform_unique_later
  end

  error_handler do |error|
    puts "*********************"
    puts "Error Running a Job"
    puts error
    puts "*********************"
  end
end
