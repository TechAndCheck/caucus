class ProcessImportJob < ApplicationJob
  queue_as :default

  def perform(file_path, job_id = self.job_id)
    logger.debug "Processing Job: #{job_id}"

    number_of_lines = `wc -l #{file_path}`.to_i

    file = File.new(file_path)
    File.foreach(file).with_index do |line, line_num|
      logger.debug(line)
      json = JSON.parse(line)
      claim = Claim.create({
        statement: json["claim"],
        speaker_name: json["author"]
      })

      json["categories"].each do |category|
        claim.categories << Category.find_or_create_by(name: category)
      end

      # Every 10 put it out
      ActionCable.server.broadcast(job_id, {
        total: number_of_lines,
        completed: line_num
      }) if line_num % 10 == 0
    end

    # Broadcast the final version
    ActionCable.server.broadcast(job_id, {
      total: number_of_lines,
      completed: number_of_lines
    })

    File.delete(file_path) if File.exists?(file_path)
  end
end
