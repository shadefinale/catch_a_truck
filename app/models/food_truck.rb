class FoodTruck < ActiveRecord::Base

  geocoded_by :address

  #only geocode if no lat/lng present, which is currently never
  after_validation :geocode, if: ->(obj){
              !(obj.latitude.present? && obj.longitude.present?) }

  #uses Database information and method included in geocoder gem
  def self.nearby_trucks(origin)
    FoodTruck.near(origin, 1) #within 1 mile
  end

  #create query string for API request
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
      #use seeded data if API fails
      return FoodTruck.nearby_trucks(origin)
    end
  end

  #process foodtruck information into usable format for front end
  def self.process_foodtruck_list(list)
    foodtrucks = []
    list.each_with_index do |truck, index|
      if truck['latitude'] && truck['longitude']
        foodtrucks.push({id: index, latitude: truck['latitude'].to_f,
                        longitude: truck['longitude'].to_f,
                        name: truck['applicant'],
                        address: truck['address'] +', San Francisco',
                        schedule: truck['dayshours'] || "",
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

  def self.open?(schedule, date)

    return false unless schedule && schedule.length > 0
    range_regex = /.+-.+:/
    cherry_regex = /([^:]+):/
    day_of_week = Time.parse(date).strftime("%A").downcase[0..1]
    if schedule =~ range_regex
      day_range = schedule.scan(range_regex)[0]
      return FoodTruck.open_date_range?(day_of_week, day_range)
    else
      days = schedule.scan(cherry_regex)[0][0].split("/")
      return FoodTruck.open_date_cherry_picked?(day_of_week, days)
    end
  end

  def open? (date)

    range_regex = /.+-.+:/
    cherry_regex = /([^:]+):/
    day_of_week = Time.parse(date).strftime("%A").downcase[0..1]
    if self.schedule =~ range_regex
      day_range = self.schedule.scan(range_regex)[0]
      return FoodTruck.open_date_range?(day_of_week, day_range)
    else
      days = self.schedule.scan(cherry_regex)[0][0].split("/")
      return FoodTruck.open_date_cherry_picked?(day_of_week, days)
    end
  end

  def FoodTruck.open_date_range?(day_of_week, day_range)
    weekdays = ['su', 'mo', 'tu', 'we', 'th', 'fr', 'sa', 'su', 'mo', 'tu', 'we', 'th', 'fr', 'sa']
    start_day = day_range[0..1].downcase
    end_day = day_range[3..4].downcase
    return false unless weekdays.include?(start_day) && weekdays.include?(end_day)
    return weekdays[weekdays.index(start_day)..weekdays[weekdays.index(start_day)..-1].index(end_day)].include? day_of_week
  end

  def FoodTruck.open_date_cherry_picked?(day_of_week, day_range)
    return day_range.map(&:downcase).include? day_of_week
  end

end
