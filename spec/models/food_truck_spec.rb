require 'rails_helper'

RSpec.describe FoodTruck, type: :model do
  let!(:truck) { create(:food_truck) }

  describe 'calculate_schedule' do
    it 'should handle range case properly (days falsey)' do
      truck.schedule = 'Mo-Fr:10AM-11AM'
      expect(truck.open?('15/9/27 7:00')).to be false
    end

    it 'should handle range case properly (days truthy)' do
      truck.schedule = 'Mo-Fr:10AM-11AM'
      expect(truck.open?('15/9/28 7:00')).to be true
    end

    it 'should handle cherry case properly (days falsey)' do
      truck.schedule = 'Th/Fr/Sa:6AM-4PM'
      expect(truck.open?('15/9/27 7:00')).to be false
    end

    it 'should handle cherry case properly (days truthy)' do
      truck.schedule = 'Th/Fr/Sa:6AM-4PM'
      expect(truck.open?('15/9/26 7:00')).to be true
    end
  end
end
