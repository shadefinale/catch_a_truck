class FoodTruck < ActiveRecord::Base

  # geocoded_by :address
  # after_validation :geocode

  def self.nearby_trucks(origin)
    FoodTruck.near(origin, 1) #within 1 mile
  end

  #get all food trucks (seeded data)
  def self.get_foodtrucks(params = "")
    api_url_base = "https://data.sfgov.org/resource/rqzj-sfat.json"
    truck_list_url = api_url_base + '?status=approved' + params
    headers = { "X-App-Token" =>
                    Rails.application.secrets.SF_API_Token }
    response_info = HTTParty.get(truck_list_url, headers)

    if response_info.code == 200
      return response_info.parsed_response # array
    else
      #error handling for API here
    end
  end

  def self.add_foodtrucks_to_DB(list)
    list.each do |truck|
      if truck['latitude'] && truck['longitude']
        FoodTruck.create( latitude: truck['latitude'],
                         longitude: truck['longitude'],
                              name: truck['applicant'],
                           address: truck['address'] +', San Francisco',
                          food_items: truck['fooditems'] )
      end
    end
  end

end
