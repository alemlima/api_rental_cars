class CategoriesController < ApplicationController
  before_action :authorize_admin
  before_action :find_category, only: [:show, :edit, :update]

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
  end
  
  def edit
  end

  def update
    @category.update(category_params)
    redirect_to @category
    flash[:notice]= 'Categoria editada com sucesso!'

  end

  def create
    @category = Category.new(category_params)
    @category.save
    redirect_to @category
    flash[:notice]= 'Categoria cadastrada com sucesso!'

  end
  private

  def find_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :daily_rate, :car_insurance,
                                     :third_party_insurance)
  end
end
