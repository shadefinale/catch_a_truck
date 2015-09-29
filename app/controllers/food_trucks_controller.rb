class FoodTrucksController < ApplicationController

  def index
    # params[:address] = '886 BRANNAN ST, San Francisco'
    if params[:address]
      @origin = Map.coordinates(params[:address])
      #@origin = [37.7697, -122.4769] #golden gate park coords
      @foodtrucks = FoodTruck.nearby_trucks_by_API(@origin)
    else
      @foodtrucks = FoodTruck.all
    end
    respond_to do |format|
      format.json {render json: @foodtrucks}
      format.html
    end
  end

  private

  # def params_list

  # end

end
