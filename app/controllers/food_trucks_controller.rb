class FoodTrucksController < ApplicationController

  def index
    # @origin = Location.findAddress(params['address'])
    # @foodtrucks = FoodTruck.nearby_trucks(@origin)

    @foodtrucks = FoodTruck.all
    respond_to do |format|
      format.json {render json: @foodtrucks}
      # format.html
    end
  end

  def show

  end

  private

  def params_list

  end

end
