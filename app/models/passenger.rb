class Passenger < ApplicationRecord
  has_many :trips

  validates :name, presence: true

  class RideRequestError < StandardError; end

  def can_request?
    trips.ongoing.count == 0
  end

  def request_ride!
    # Check if we can request a new ride
    raise RideRequestError.new("Passenger cannot currently request rides") unless can_request?

    # Find an available driver and create a trip with them, if possible
    driver = Driver.available.sample

    if driver.nil?
      raise RideRequestError.new("Passenger cannot currently request rides")
    end

    trips.create(passenger: self,
                 driver: driver,
                 date: Date.today,
                 price: rand(1000) / 10.0) if driver
  end

  def current_trip
    trips.ongoing.first
  end

  def complete_trip!(rating)
    if self.current_trip.nil?
      raise RideRequestError.new("Passenger cannot currently request rides")
    end
    current_trip.update(rating: rating)
  end
end
