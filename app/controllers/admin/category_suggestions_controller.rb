module Admin
  class CategorySuggestionsController < Admin::ApplicationController
    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    # def update
    #   super
    #   send_foo_updated_email(requested_resource)
    # end

    def approve
      @category_suggestion = CategorySuggestion.find(params[:category_suggestion_id])
      @category_suggestion.approve
      redirect_back fallback_location: admin_category_suggestions_path, notice: "\"#{@category_suggestion.name}\" approved"
    end

    def reject
      @category_suggestion = CategorySuggestion.find(params[:category_suggestion_id])
      @category_suggestion.reject
      redirect_back fallback_location: admin_category_suggestions_path, error: "\"#{@category_suggestion.name}\" rejected"
    end

    def assign_similar_category
      category = Category.find(params[:category_id])
      category_suggestion = CategorySuggestion.find(params[:category_suggestion_id])
      category_suggestion.assign_similar_category(category)
      redirect_back fallback_location: admin_category_suggestions_path, error: "\"#{category.name}\" assigned"
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
    def scoped_resource
      resource_class.where({ status: :awaiting_review })
    end

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
  end
end
