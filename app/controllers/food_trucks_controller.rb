class FoodTrucksController < ApplicationController

  def index
    # params[:address] = '886 BRANNAN ST, San Francisco'
    if params[:address] && params[:address].length > 0
      @origin = Map.coordinates(params[:address])
      #@origin = [37.7697, -122.4769] #golden gate park coords
      @foodtrucks = FoodTruck.nearby_trucks_by_API(@origin)
    else
      @origin ||= [37.7697, -122.4769]
      @foodtrucks = FoodTruck.all.as_json
    end

    @foodtrucks.select! {|truck| FoodTruck.open?(truck["schedule"] || truck[:schedule], Time.now.to_s) }

    respond_to do |format|
      format.json {render json: {markers: @foodtrucks.to_json, center: {latitude: @origin[0], longitude: @origin[1]} }}
      format.html
    end
  end

  private

  # def params_list

  # end

end
