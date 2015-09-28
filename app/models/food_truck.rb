class FoodTruck < ActiveRecord::Base

  def self.nearby_trucks(origin)
    self.get_foodtrucks()
  end

  #get all food trucks (seeded data)
  def self.get_foodtrucks
    api_url_base = "https://data.sfgov.org/resource/rqzj-sfat.json"

    truck_list_url = api_url_base + '?status=approved'
    headers = { "X-App-Token" => "" }
    response_info = HTTParty.get(truck_list_url, headers)
    list = response_info.parsed_response # array

    FoodTruck.add_foodtrucks_to_DB(list)
  end

  def self.add_foodtrucks_to_DB(list)
    list.each do |truck|
      FoodTruck.create( latitude:   truck['location']['latitude'],
                        longitude:  truck['location']['longitude'],
                        name:       truck['applicant'],
                        address:    truck['address'],
                        food_items: truck['fooditems'] )
    end
  end


end
