class Workflow::StoriesController < ApplicationController
  def index
    @product = Product.friendly.find(params[:product_id])
    @stories = @product.stories
  end
end