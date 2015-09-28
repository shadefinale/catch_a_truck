class Map

  #yields coordinates in format [37.7749295, -122.4194155]
  def self.coordinates(address_str)
    address_str += ", San Francisco"
    Geocoder.coordinates(address_str)
  end

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

end
