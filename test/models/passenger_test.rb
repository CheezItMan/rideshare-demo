require "test_helper"

describe Passenger do
  let (:passenger) { passengers(:ada) }
  it "can be instantiated" do
    # Arrange & Act
    passenger = Passenger.new(name: "Katie Bouman",
                              phone_number: "111-111-1111")

    # Assert
    expect(passenger.valid?).must_equal true
  end

  it "will have the required fields" do
    # Arrange
    [:name, :phone_number].each do |field|
      # Assert
      expect(passenger).must_respond_to field
    end
  end

  describe "relationships" do
    it "will have trips" do
      expect(passenger).must_respond_to :trips

      passenger.trips.each do |trip|
        expect(trip).must_be_instance_of Trip
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      passenger.name = nil

      expect(passenger.valid?).must_equal false
      expect(passenger.errors.keys).must_equal [:name]
    end
  end

  describe "custom methods" do
    describe "can_request?" do
      it "will return true if they can request a ride" do
        expect(passenger.can_request?).must_equal true
      end

      it "will return false if they cannot" do
        passenger.request_ride!

        expect(passenger.can_request?).must_equal false
      end
    end

    describe "request_ride!" do
      it "can request a ride if not on a trip" do
        trips_before = passenger.trips.count
        passenger.request_ride!

        expect(trips_before).must_equal passenger.trips.count - 1
      end

      it "will raise RideRequestError if already on a trip" do
        passenger.request_ride!
        trips_before = passenger.trips.count

        expect {
          passenger.request_ride!
        }.must_raise Passenger::RideRequestError

        expect(trips_before).must_equal passenger.trips.count
      end

      it "will raise a RideRequestError if all drivers are busy" do
        # Arrange
        Driver.all.each do |driver|
          driver.active = false
          driver.save
        end

        trips_before = passenger.trips.count
        expect {
          # Act
          passenger.request_ride!

          # Assert
        }.must_raise Passenger::RideRequestError

        expect(trips_before).must_equal passenger.trips.count
      end
    end

    describe "current_trip" do
    end

    describe "complete_trip!" do
    end
  end
end
