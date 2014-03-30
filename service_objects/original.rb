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
    latitude = params[:latitude]
    longitude = params[:longitude]

    location = Location.where(latitude: latitude, longitude: longitude).first

    if location.present?
      location.touch
    else
      location = Location.new(latitude: latitude, longitude: longitude)
      location.save
    end

    index
  end
end

# The create method has a good amount of logic that we would have to repeat should we want to
# create a Location object in other parts of the code.  A better way of doing this would be to
# have the create logic in a service object.
#
# From (http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/), 
# we may choose to use service objects when:
# The action is complex (e.g. closing the books at the end of an accounting period)
# The action reaches across multiple models (e.g. an e-commerce purchase using Order, CreditCard and Customer objects)
# The action interacts with an external service (e.g. posting to social networks)
# The action is not a core concern of the underlying model (e.g. sweeping up outdated data after a certain time period).
# There are multiple ways of performing the action (e.g. authenticating with an access token or password). This is the Gang of Four Strategy pattern.
#
# See refactored.rb as an example of using a service object.
