class CreateGeologicalLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :geological_locations do |t|

      t.timestamps
    end
  end
end
