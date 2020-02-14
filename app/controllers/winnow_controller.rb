class WinnowController < ApplicationController
  before_action :verify_claim, except: [:index]
  before_action :authenticate_user!

  def index
    @claim = new_claim
    # We only want categories not already assigned to the claim
    @categories = Category.all.order("name ASC") - @claim.categories
    turbolinks_animate "slideInRight"
  end

  def submit
    category_ids = split_category_ids(claim_params[:categories])
    @categories = category_ids.map do |id|
      Category.find(id)
    end
    @claim.update!({ categories: @categories, checked: true })

    redirect_to winnow_index_url
  end

private

  def verify_claim
    @claim = Claim.find(claim_params[:id])
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  def claim_params
    params.require(:claim).permit(:id, :categories)
  end

  def split_category_ids(id_string)
    seperator = ":::"
    id_string.split(seperator)
  end

  # Get a new claim to show to a user
  # This could get interesting with locks and such so it's a seperate function
  def new_claim
    claim = Claim.where(checked: false).order("RANDOM()").first
    claim
  end
end
