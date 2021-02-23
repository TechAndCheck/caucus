require 'aws-sdk-s3'

module Admin
  class ClaimsController < Admin::ApplicationController
    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    # def update
    #   super
    #   send_foo_updated_email(requested_resource)
    # end

    def export
      # Only export claims with at least one category.
      minimum_categories = params["minimum_categories"].blank? ? 0 : params["minimum_categories"].to_i
      # claims = Claim.joins(:categories).where.not(categories: []).where("categories_count > #{minimum_categories}").distinct
      categories = Category.where("claims_count > #{minimum_categories}").distinct
      claim_ids = ActiveRecord::Base.connection.execute(
        " SELECT DISTINCT claims.id
          FROM claims
          INNER JOIN categories_claims
          ON claims.id = categories_claims.claim_id
          WHERE categories_claims.category_id in (
            SELECT categories.id
            FROM categories
            WHERE categories.claims_count > #{params["minimum_categories"]}
          )
        "
      ).values.flatten
      claims = Claim.includes([:categories]).where(id: claim_ids).distinct

      exporter = CsvBinaryMlExporter.new({
        claims: claims,
        categories: categories
      })
      processed = exporter.process(response, headers)

      # send_data csv
      respond_to do |format|
        format.csv do
          # rubocop:disable Lint/UselessAssignment
          headers = processed[:headers]
          response = processed[:response]
          self.response_body = processed[:enumerator]
          # rubocop:enable Lint/UselessAssignment
        end
      end
    end

    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    # def find_resource(param)
    #   Foo.find_by!(slug: param)
    # end

    # The result of this lookup will be available as `requested_resource`

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    # def scoped_resource
    #   if current_user.super_admin?
    #     resource_class
    #   else
    #     resource_class.with_less_stuff
    #   end
    # end

    # Override `resource_params` if you want to transform the submitted
    # data before it's persisted. For example, the following would turn all
    # empty values into nil values. It uses other APIs such as `resource_class`
    # and `dashboard`:
    #
    # def resource_params
    #   params.require(resource_class.model_name.param_key).
    #     permit(dashboard.permitted_attributes).
    #     transform_values { |value| value == "" ? nil : value }
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def import_show
    end

    def import_submit
      # Save the file to a temp file on the system if we're in dev.
      # If we're in prod or `UPLOAD_IMPORT_TO_S3` is set to 'true' we upload to S3 instead
      # This is done because, if we're in Heroku, the ProcessImportJob runs on a different container
      # so the temp file won't move over. We could just send the data to the job, but if it's a big
      # file that'd gum up the works something horrible.

      redirect_back if params[:file].nil?

      uuid = SecureRandom.uuid # We use a uuid in two place, why not just make one?
      job = nil
      if Rails.env.production? || Figaro.env.UPLOAD_IMPORT_TO_S3.downcase == 'true'
        file_name = uuid
        object_key = upload_file(file_name, params[:file].path)
        job = ProcessImportJob.set(wait: 10.seconds).perform_later(aws_object_key: object_key)
      else
        new_file_path = "./tmp/#{uuid}-#{params[:file].original_filename}"
        FileUtils.cp(params[:file].to_path, new_file_path)

        job = ProcessImportJob.set(wait: 2.seconds).perform_later(file_path: new_file_path)
      end

      render json: {'jobId': job.job_id}
    end

  private

    def upload_file(object_key, file_path)
      s3 = Aws::S3::Resource.new(region: Figaro.env.AWS_REGION)

      bucket = s3.bucket(Figaro.env.AWS_IMPORT_BUCKET)
      object = bucket.object(object_key)
      object.upload_file(file_path)
      object.wait_until_exists

      return object.key
    rescue StandardError => e
      byebug
      raise "Error uploading object for import: #{e.message}"
    end
  end
end
