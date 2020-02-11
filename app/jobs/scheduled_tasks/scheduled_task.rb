# Borrowed from https://medium.com/carwow-product-engineering/moving-from-heroku-scheduler-to-clockwork-and-sidekiq-7b05f63d0d24
#
module ScheduledTasks
  # This maintains the lifecylce of the tasks, making sure that it's not enqueued if already running.
  class ScheduledTask < ActiveJob::Base
    queue_as :default

    def self.perform_unique_later(*args)
      if task_already_scheduled?
        logger.warn "Task #{self} already enqueued/running."
        return
      end

      jobs = perform_later(*args)
      jobs
    end

    def self.task_already_scheduled?
      job_type = to_s
      queue_name = "default"
      q = Sidekiq::Queue.new(queue_name)
      is_enqueued = q.any? { |j| j["args"][0]["job_class"] == job_type }

      workers = Sidekiq::Workers.new
      is_running = workers.any? do |_x, _y, work|
        work["queue"] == queue_name &&
          work["payload"]["args"][0]["job_class"] == job_type
      end

      is_enqueued || is_running
    end
  end
end
