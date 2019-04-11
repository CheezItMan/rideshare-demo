# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "vinbot"
require "faker"

CARS = [["Honda", "Accord"], ["Tesla", "Model X"], ["Chevy", "Nova"], ["Honda", "Civic"], ["VW", "Beetle (old)"], ["VW", "Beetle (new)"], ["Chrystler", "PT Cruiser"], ["Ford", "Pinto"]]

drivers = []
passengers = []

50.times do
  car = CARS.sample
  driver = Driver.new name: Faker::Movies::LordOfTheRings.character, vin: Vinbot::Vin.generate, car_make: car[0], car_model: car[1], active: rand(100) > 70

  while Driver.find_by(name: driver.name) != nil
    driver.name = Faker::Name.name
  end
  driver.save
  drivers.push(driver)
end

150.times do
  passenger = Passenger.new name: Faker::Movies::HarryPotter.character, phone_number: Faker::PhoneNumber.cell_phone

  passenger.save
  passengers.push(passenger)
end

# Create completed trips
500.times do
  trip = Trip.new
  trip.date = Faker::Date.between(1.year.ago, Date.today)
  trip.rating = 1 + rand(4) # between 1 and 5
  trip.driver = drivers.sample
  trip.passenger = passengers.sample
  trip.price = rand(1000) / 10.0

  trip.save
end

# Create some ongoing trips, leaving a few available drivers
active_drivers = drivers.select { |d| d.active? }
ongoing_trips = drivers.length - [rand(5..15), active_drivers.length].min

passengers.sample(ongoing_trips).zip(active_drivers.sample(ongoing_trips)).each do |passenger, driver|
  trip = Trip.new(passenger: passenger, driver: driver, date: Date.today, price: rand(1000) / 10.0)
  trip.save
end
