class AddColumnToFoodTrucks < ActiveRecord::Migration
  def change
    add_column :food_trucks, :schedule, :text, null: false
  end
end
