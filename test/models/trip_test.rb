require "test_helper"

describe Trip do
  let (:trip) { trips(:one) }
  it "can be instantiated" do
    # Arrange & Act
    trip = Trip.new(
      date: "2019-01-01",
      rating: 3,
      driver_id: drivers(:dan).id,
      passenger_id: passengers(:ada).id,
      price: 3.25,
    )

    # Assert
    expect(trip.valid?).must_equal true
  end

  it "will have the required fields" do
    # Arrange
    [:date, :rating, :driver_id, :passenger_id, :price].each do |field|
      # Assert
      expect(trip).must_respond_to field
    end
  end

  describe "relationships" do
    it "will belong to a driver" do
      # Assert
      expect(trip).must_respond_to :driver
      expect(trip.driver).must_be_instance_of Driver
    end

    it "will belong to a passenger" do
      # Assert
      expect(trip).must_respond_to :passenger
      expect(trip.passenger).must_be_instance_of Passenger
    end
  end

  describe "validations" do
    it "must have a price" do
      # Arrange
      trip.price = nil

      # Assert
      expect(trip.valid?).must_equal false
      expect(trip.errors.keys).must_equal [:price]
    end

    it "must have a driver" do
      # Arrange
      trip.driver = nil

      # Assert
      expect(trip.valid?).must_equal false
      expect(trip.errors.keys).must_equal [:driver]
    end

    it "must have a passenger" do
      # Arrange
      trip.passenger = nil

      # Assert
      expect(trip.valid?).must_equal false
      expect(trip.errors.keys).must_equal [:passenger]
    end
  end

  describe "custom methods" do
  end
end
