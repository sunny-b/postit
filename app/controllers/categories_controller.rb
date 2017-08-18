class CategoriesController < ApplicationController
  before_action :require_user, only: [:new, :create]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(categories_params)

    if @category.save
      flash[:notice] = 'Your Category was created successfully!'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @category = Category.find_by(slug: params[:id])
  end

  private

  def categories_params
    params.require(:category).permit(:name)
  end
end