# Borrowed from https://medium.com/carwow-product-engineering/moving-from-heroku-scheduler-to-clockwork-and-sidekiq-7b05f63d0d24
namespace :scheduled_tasks do
  require "./app/jobs/scheduled_tasks/scheduled_task"
  Dir[File.join(".", "app/jobs/scheduled_tasks/**/*.rb")].each { |f| require f }

  classes = ObjectSpace.each_object(Class).select { |klass| klass < ScheduledTasks::ScheduledTask }

  classes.each do |klass|
    class_name = klass.to_s
    task_name = class_name.gsub("ScheduledTasks::", "").gsub("::", ":").underscore

    desc "Runs #{class_name}"
    task task_name => :environment do
      puts "Executing job #{klass}"
      klass.perform_now
    end
  end
end
