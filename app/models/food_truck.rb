class FoodTruck < ActiveRecord::Base

  geocoded_by :address

  #only geocode if no lat/lng present, which is currently never
  after_validation :geocode, if: ->(obj){
              !(obj.latitude.present? && obj.longitude.present?) }

  #uses Database information
  def self.nearby_trucks(origin)
    FoodTruck.near(origin, 1) #within 1 mile
  end

  def self.nearby_trucks_by_API(origin)
    if origin # latitude and longitude array
      # 1 mile to 1609.34 meters conversion for API
      meters = 1609.34
      query_string = '&$where=within_circle(location,'
      query_string += origin[0].to_s + ',' + origin[1].to_s
      query_string += ',' + meters.to_s + ')'
    end
    return FoodTruck.get_foodtrucks(origin, query_string)
  end

  #get all food trucks (seeded data)
  def self.get_foodtrucks(origin = "", query = "")
    api_url_base = "https://data.sfgov.org/resource/rqzj-sfat.json"
    truck_list_url = api_url_base + '?status=approved' + query

    headers = { "X-App-Token" =>
                    Rails.application.secrets.SF_API_Token }
    response_info = HTTParty.get(truck_list_url, headers)
    if response_info.code == 200
      list = response_info.parsed_response
      return FoodTruck.process_foodtruck_list(list) # array

    else
      FoodTruck.nearby_trucks(origin) #use seeded data if API fails
    end

  end

  def self.process_foodtruck_list(list)
    foodtrucks = []
    list.each do |truck|
      if truck['latitude'] && truck['longitude']
        foodtrucks.push({latitude: truck['latitude'],
                         longitude: truck['longitude'],
                              name: truck['applicant'],
                           address: truck['address'] +', San Francisco',
                          food_items: truck['fooditems']} )
      end
    end
    return foodtrucks
  end

  #to save into database
  def self.add_foodtrucks_to_DB(processed_list)
    processed_list.each do |truck|
      if truck[:latitude] && truck[:longitude]
        FoodTruck.create(truck)
      end
    end
  end

end
