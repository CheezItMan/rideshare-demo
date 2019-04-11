require "test_helper"

describe TripsController do
  let (:trip_hash) {
    {
      trip: {
        driver_id: Driver.first.id,
        passenger_id: Passenger.last.id,
        "date(1i)" => "2018",
        "date(2i)" => "4",
        "date(3i)" => "4",
        rating: 4,
        price: 37.50,
      },
    }
  }
  describe "show" do
    it "can get an individual trip" do
      # Arrange
      trip = Trip.first

      # Act
      get passenger_trip_path(trip.passenger.id, trip.id)

      # Assert
      must_respond_with :success
    end

    it "will respond with redirect if trying to show an invalid trip" do
      # Arrange
      trip = Trip.first

      # Act
      get passenger_trip_path(trip.passenger.id, -1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "can get an individual trip" do
      # Arrange
      trip = Trip.first

      # Act
      get edit_passenger_trip_path(trip.passenger.id, trip.id)

      # Assert
      must_respond_with :success
    end

    it "will respond with redirect if trying to show an invalid trip" do
      # Arrange
      trip = Trip.first

      # Act
      get edit_passenger_trip_path(trip.passenger.id, -1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "update" do
    it "can update an existing trip" do
      # Arrange
      trip = Trip.first

      # Act
      patch passenger_trip_path(trip.passenger.id, trip.id), params: trip_hash

      # Assert
      must_respond_with :redirect

      trip.reload
      expect(trip.driver).must_equal Driver.find_by(id: trip_hash[:trip][:driver_id])
      expect(trip.passenger).must_equal Passenger.find_by(id: trip_hash[:trip][:passenger_id])
      expect(trip.price).must_equal trip_hash[:trip][:price]
      expect(trip.rating).must_equal trip_hash[:trip][:rating]
      expect(trip.driver_id).must_equal trip_hash[:trip][:driver_id]
      expect(trip.passenger_id).must_equal trip_hash[:trip][:passenger_id]
    end
  end

  describe "create" do
    it "can create a valid trip" do
      expect {
        # Act
        post passenger_trips_path(trip_hash[:trip][:passenger_id])

        # Assert
      }.must_change "Trip.count", 1

      must_respond_with :redirect
    end

    it "will not create a trip with invalid data" do
      # Arrange
      trip_hash[:trip][:price] = -1

      expect {
        # Act
        post passenger_trips_path(-1)

        # Assert
      }.wont_change "Trip.count"

      must_respond_with :redirect
    end
  end

  describe "destroy" do
    it "can destory existing trips" do
      # Arrange
      trip = Trip.last
      expect {
        # Act
        delete trip_path(trip.id)

        # Assert
        must_respond_with :redirect
      }.must_change "Trip.count", -1
    end

    it "will redirect back if given an invalid id" do
      # Arrange
      trip = Trip.last
      expect {

        # Act
        delete trip_path(-1)

        # Assert
        must_respond_with :redirect
      }.wont_change "Trip.count"
    end
  end
end
