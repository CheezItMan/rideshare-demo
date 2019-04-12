require "test_helper"

describe Driver do
  let (:driver) { drivers(:dan) }
  it "can be instantiated" do
    # Arrange & Act
    driver = Driver.new(name: "Kari", vin: "123", active: true,
                        car_make: "Cherry", car_model: "DR5")

    # Assert
    expect(driver.valid?).must_equal true
  end

  it "will have the required fields" do
    # Arrange
    driver = Driver.first
    [:name, :vin, :active, :car_make, :car_model].each do |field|
      # Assert
      expect(driver).must_respond_to field
    end
  end

  describe "relationships" do
    it "will have trips" do
      # Assert
      expect(driver).must_respond_to :trips

      driver.trips.each do |trip|
        expect(trip).must_be_instance_of Trip
      end
    end
  end

  describe "validations" do
    it "must have a name" do
      # Arrange
      driver.name = nil

      # Assert
      expect(driver.valid?).must_equal false
      expect(driver.errors.keys).must_equal [:name]
    end
  end

  describe "custom methods" do
    describe "average_rating" do
      it "will return 0 for a driver with no trips" do
        # Arrange
        new_driver = Driver.new

        # Assert
        expect(new_driver.average_rating).must_equal 0
      end

      it "will calculate the average for a driver with trips" do
        # Assert
        expect(driver.average_rating).must_be_close_to ((5 + 2) / 2.0), 0.01
      end
    end

    describe "make_and_model" do
      it "will return make and model as one string" do
        # Act-Assert
        # yep, this make-model doesn't really exist
        expect(driver.make_and_model).must_equal "Honda Nova"
        # Arrange
        driver.car_make = "Tesla"
        # Act-Assert
        expect(driver.make_and_model).must_equal "Tesla Nova"
        # Act-Assert
        driver.car_model = "Leaf"
        expect(driver.make_and_model).must_equal "Tesla Leaf"
      end
    end
  end
end
