class Map

  def self.locate_user(address, user_ip)
    if address.blank?
      address = Map.address_from_ip(user_ip)
      address ||= 'San Francisco'
    end
    coord = self.coordinates(address)
    return coord, address
  end

  def self.address_from_ip(user_ip)
    if user_ip && user_ip.address != "Reserved"
        return user_ip.address
    end
  end


  #yields coordinates in format [37.7749295, -122.4194155]
  def self.coordinates(address_str)
    address_str += ", San Francisco"
    Geocoder.coordinates(address_str)
  end


  # generate map markers for foodtruck locations

  def self.map_markers(trucks)
    Gmaps4rails.build_markers(trucks) do |location, marker|
      marker.lat  truck[:latitude]
      marker.lng  truck[:longitude]
      marker.infowindow truck[:name] + '<br>' +
                        truck[:address] + '<br>' +
                        truck[:food_items]
    end
  end

  def self.no_results(lat, lon)
    #create default location
    location ={ latitude: lat,
                longitude: lon,
                address: "You are here"
              }

    self.map_markers([location])
  end

end
