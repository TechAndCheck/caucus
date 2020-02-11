class CategoriesController < ApplicationController
  before_action :check_for_category, only: [:show, :update, :destroy]

  def index
    @categories = Category.all
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create(category_params)

    redirect_back unless @category.valid?

    redirect_to category_path(@category), flash: { success: "Successfully created category" }
  end

  def update
    @category = Category.find(params[:id])

    @category.update(category_params)
    redirect_to category_path, flash: { success: "Successfully created category" }
  end

  def destroy
    @category = Category.find(params[:id])
    @category.delete

    redirect_to categories_path, flash: { success: "Successfully deleted category" }
  end

private

  def check_for_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_back fallback_location: categories_path, flash: { error: "Category not found with id #{params[:id]}" }
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
