class FoodTrucksController < ApplicationController

  def index
    # @origin = Location.findAddress(params['address'])
    @foodtrucks = FoodTruck.nearby_trucks(@origin)
  end

  def show

  end

  private

  def params_list

  end

end
