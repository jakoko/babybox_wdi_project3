class ProductsController < ApplicationController
  require_relative "ShopStyleAPI.rb"
  require_relative "GirlsShopStyleAPI.rb"

	def index

	end 

	def new
    session[:shirt_size]   = filters_params[:shirt_size].to_i
    session[:jacket_size]  = filters_params[:jacket_size].to_i
    session[:pant_size]    = filters_params[:pants_size].to_i
    session[:price]        = filters_params[:price]
    session[:gender]       = filters_params[:gender]
    session[:style]        = filters_params[:style].to_i
    
    call_api = GirlsShopStyleAPI.new(filters_params[:style],filters_params[:shirt_size],filters_params[:pants_size],filters_params[:jacket_size],filters_params[:gender],filters_params[:price]) if filters_params[:gender] == "girl"

    call_api = ShopStyleAPI.new(filters_params[:style],filters_params[:shirt_size],filters_params[:pants_size],filters_params[:jacket_size],filters_params[:gender],filters_params[:price]) if filters_params[:gender] == "boy"

    @jacket_products  = call_api.jacket_API_data
    @shirt_products   = call_api.shirt_API_data
    @bottom_products  = call_api.bottoms_API_data
	end

  def show
    @products = product_ids_params
    
    @shirt_info = GirlsShopStyleAPI.product_info(@products["shirt_id"]) if !product_ids_params["shirt_id"].nil?
    @jacket_info = GirlsShopStyleAPI.product_info(@products["jacket_id"]) if !product_ids_params["jacket_id"].nil?
    @bottom_info = GirlsShopStyleAPI.product_info(@products["bottom_id"]) if !product_ids_params["bottom_id"].nil?
    
  end

  def filter

  end

  private
  def product_ids_params
    params.fetch("product_ids", {}).permit("shirt_id", "jacket_id", "bottom_id")
  end

  def filters_params
    params.require(:product).permit(:shirt_size, :pants_size, :jacket_size, :gender, :style, :price)
  end

end
