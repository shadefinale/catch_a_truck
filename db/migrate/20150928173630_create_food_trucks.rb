class CreateFoodTrucks < ActiveRecord::Migration
  def change
    create_table :food_trucks do |t|
      t.string      :name,       null: false
      t.string      :address,    null: false
      t.string      :food_items, null: false
      t.float       :latitude,   null: false
      t.float       :longitude,  null: false

      t.timestamps null: false
    end

    add_index :food_trucks, :name
    add_index :food_trucks, :food_items
    add_index :food_trucks, [:latitude, :longitude]
  end

end
