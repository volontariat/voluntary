class Workflow::ProductsController < ApplicationController
  def show
    @stories = Product.stories(params[:id], current_user, params[:page])
    @product = Product.friendly.find(params[:id]) unless params[:id] == 'no-name'
  end
end