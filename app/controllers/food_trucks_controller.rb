class FoodTrucksController < ApplicationController

  def index
    params[:address] = '886 BRANNAN ST, San Francisco'
    if params[:address]
      @origin = Map.coordinates(params[:address])
      @foodtrucks = FoodTruck.nearby_trucks(@origin)
    else
      @foodtrucks = FoodTruck.all
    end

    respond_to do |format|
      format.json {render @foodtrucks}
      format.html
    end
  end

  def show
    if params[:address]

    else
      @foodtrucks = FoodTruck.all
    end

    respond_to do |format|
      format.json {render @foodtrucks}
      format.html
    end
  end

  private

  def params_list

  end

end