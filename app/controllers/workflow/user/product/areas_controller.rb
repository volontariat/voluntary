class Workflow::User::Product::AreasController < ApplicationController
  def show
    @area = Area.friendly.find(params[:id])
    @areas = @area.children_for_product_id(params[:product_id])
    @projects = @area.projects.for_product_id(params[:product_id])
    @product = ::Product.find(params[:product_id]) unless params[:product_id] == 'no-name'
  end
end