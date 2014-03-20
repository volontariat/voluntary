class Workflow::ProductsController < ApplicationController
  def show
    @stories = Product.stories(params[:id], current_user)
    @areas = Area.find_by_product_id(params[:id])
    @product = Product.find(params[:id]) unless params[:id] == 'no-name'
  end
end
