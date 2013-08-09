class Workflow::User::Product::AreasController < ApplicationController
  def show
    @area = Area.find(params[:id])
    @areas = @area.children_for_product_id(params[:product_id])
    @projects = @area.projects.for_product_id(params[:product_id])
  end
end