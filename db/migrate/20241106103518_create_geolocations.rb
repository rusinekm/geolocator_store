# frozen_string_literal: true

class CreateGeolocations < ActiveRecord::Migration[7.0]
  def change
    create_table :geolocations do |t|
      t.string :ip
      t.decimal :latitude, precision: 8, scale: 6
      t.decimal :longitude, precision: 9, scale: 6
      t.string :city
      t.string :country_name

      t.timestamps
    end
  end
end
