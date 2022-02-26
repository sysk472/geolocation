class CreateGeolocations < ActiveRecord::Migration[7.0]
  def change
    create_table :geolocations do |t|
      t.string :ip
      t.string :url
      t.jsonb :data
      t.timestamps
    end
  end
end
