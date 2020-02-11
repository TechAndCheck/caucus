module ScheduledTasks
  module FactStream
    # This is the task that checks for new fact checks from FactStream.
    # It then save them as claims
    class Import < ScheduledTask
      def perform
        print_start_message
        start
      end

    private

      def start
        fact_checks = FactStreamClient.new.all_fact_checks(true)
        print "Saved #{fact_checks.count} new claims.\n"
      end

      def print_start_message
        puts "Importing FactStream fact checks..."
        puts "********************************"
      end
    end
  end
end
