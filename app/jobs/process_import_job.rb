require "aws-sdk-s3"

class ProcessImportJob < ApplicationJob
  queue_as :default

  def perform(job_id = self.job_id, aws_object_key: nil, file_path: nil)
    logger.debug "Processing Job: #{job_id}"

    raise "Must pass in `aws_object_key` or `file_path`" if aws_object_key.nil? && file_path.nil?

    begin
      s3 = Aws::S3::Client.new

      file = nil
      unless file_path.nil?
        file = File.new(file_path)

      else
        file = Tempfile.new(SecureRandom.uuid)

        s3.get_object(bucket: Figaro.env.AWS_IMPORT_BUCKET, key: aws_object_key) do |chunk|
          file.write(chunk.force_encoding("UTF-8"))
        end
        s3.delete_object(bucket: Figaro.env.AWS_IMPORT_BUCKET, key: aws_object_key)
      end

      number_of_lines = `wc -l #{file.path}`.to_i

      File.foreach(file).with_index do |line, line_num|
        logger.debug(line)
        json = JSON.parse(line)
        claim = Claim.create({
          statement: json["claim"],
          speaker_name: json["author"],
          article: json["article"]
        })

        json["categories"].each do |category|
          claim.categories << Category.find_or_create_by(name: category)
        end

        begin
          claim.save!
        rescue Exception => e
          logger.debug("Exception when saving claim #{claim}")
          logger.debug("#{e}")
          raise e
          # Eat it and move forward
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
    rescue Exception => e
      logger.warn("Exception: #{e}")
      raise e
    ensure
      begin
        # Handle the temp file
        file.close
        file.unlink
      rescue Exception => e
        logger.warn "Exception raised when processing import: #{e}"
        # If there's an exception let's delete the file instead
        File.delete(file_path) if File.exist?(file_path)
      end
    end
  end
end
