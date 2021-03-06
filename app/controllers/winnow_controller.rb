class WinnowController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_winnowable_claim, only: [:index]
  before_action :verify_claim, except: [:index]

  def index
    # We only want categories not already assigned to the claim
    @categories = Category.all.order("name ASC") - @claim.categories
    turbolinks_animate "slideInRight"
  end

  def submit
    category_ids = split_submitted_array(claim_params[:categories])
    @categories = category_ids.map do |id|
      Category.find(id)
    end

    @claim.update!({ categories: @categories, checked: true })

    category_suggestions = split_submitted_array(claim_params[:suggestions])
    @category_suggestions = category_suggestions.map do |name|
      CategorySuggestion.create!({ name: name, user: current_user, claim: @claim })
    end

    redirect_to winnow_index_url
  end

private

  def verify_claim
    @claim = Claim.find(claim_params[:id])
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  def verify_winnowable_claim
    @claim = winnowable_claim
    if @claim.nil?
      redirect_to root_path, flash: { notice: "Looks like there are no claims to winnow. Go do something else fun!" }
    end
  end

  def claim_params
    params.require(:claim).permit(:id, :categories, :suggestions)
  end

  def split_submitted_array(id_string)
    seperator = ":::"
    id_string.split(seperator)
  end

  # Choose and return a claim that we want the user to winnow. (This could get interesting with
  # locks and such so it's a separate method.)
  def winnowable_claim
    claim = Claim.where(checked: false).order("RANDOM()").first
    claim
  end
end
