class WinnowController < ApplicationController
  def index
  end

  def submit
    category_ids = split_category_ids(params[:categories])
    @categories = category_ids.map do |id|
      Category.find(id)
    end

    redirect_to :root
  end

  private

    def split_category_ids(id_string)
      seperator = ":::"
      id_string.split(seperator)
    end
end
