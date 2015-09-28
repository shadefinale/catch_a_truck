class FoodTruck < ActiveRecord::Base

  def self.nearby_trucks(origin)
    self.get_foodtrucks()
  end

  #get all food trucks (seeded data)
  def self.get_foodtrucks
    api_url_base = "https://data.sfgov.org/resource/rqzj-sfat.json"

    truck_list_url = api_url_base + '?status=approved'
    headers = { "X-App-Token" =>
                    Rails.application.secrets.SF_API_Token }
    response_info = HTTParty.get(truck_list_url, headers)

    if response_info.code == 200
      list = response_info.parsed_response # array
      FoodTruck.add_foodtrucks_to_DB(list)
    else
      #error handling for API here
    end
  end

  def self.add_foodtrucks_to_DB(list)
    list.each do |truck|
      if truck['latitude'] && truck['longitude']
        FoodTruck.create( latitude:   truck['latitude'],
                          longitude:  truck['longitude'],
                          name:       truck['applicant'],
                          address:    truck['address'],
                          food_items: truck['fooditems'] )
      end
    end
  end


end
