# db/migrations/xxx_create_locations.rb
#class CreateLocations < ActiveRecord::Migration
  #def change
    #create_table :locations do |t|
      #t.decimal :latitude
      #t.decimal :longitude
      #t.timestamps
    #end
  #end
#end

# app/models/location
class Location # < ActiveRecord::Base

end

# app/controllers/locations_controller.rb
class LocationsController # < ApplicationController
  def index
    @locations = Location.find(:all, order: 'updated_at desc', limit: 100)
    respond_to do |format|
      format.html
      format.json { render json: @location }
    end
  end

  def create
    LocationCreator.new(params[:latitude], params[:longitude]).create!
    index
  end
end

# app/services/location_creator.rb
class LocationCreator
  attr_reader :latitude, :longitude

  def initialize(lat, lng)
    @latitude = lat
    @longitude = lng
  end

  def create!
    @location = Location.where(latitude: latitude, longitude: longitude).first

    if @location.present?
      @location.touch
    else
      @location = Location.new(latitude: latitude, longitude: longitude)
      @location.save
    end
  end
end
