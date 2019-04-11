require "test_helper"

describe DriversController do
  let (:driver_hash) {
    {
      driver: {
        name: "Peter Parker",
        vin: "3333",
        car_make: "GM",
        car_model: "Bolt",
      },
    }
  }

  describe "index" do
    it "can get index" do
      # Act
      get drivers_path

      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "can get a valid Driver" do
      # Arrange
      driver = Driver.first

      # Act
      get driver_path(driver.id)

      # Assert
      must_respond_with :success
    end

    it "will respond with a redirect with an invalid driver" do
      # Act
      get driver_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "can get the edit form for a valid driver" do
      # Arrange
      driver = Driver.first

      # Act
      get edit_driver_path(driver.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect if trying to edit a driver that can't be found" do
      # Act
      get edit_driver_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "update" do
    it "can update an existing driver" do
      # Arrange
      driver = Driver.first

      # Act
      patch driver_path(driver.id), params: driver_hash

      # Assert
      must_respond_with :redirect

      driver.reload
      driver_hash[:driver].keys.each do |key|
        expect(driver[key]).must_equal driver_hash[:driver][key]
      end
    end

    it "will not update a driver if given invalid data" do
      # Arrange
      driver = Driver.first
      old_name = driver.name
      driver_hash[:driver][:name] = nil

      # Act
      patch driver_path(driver.id), params: driver_hash

      # Assert
      must_respond_with :redirect

      driver.reload
      expect(driver.name).must_equal old_name
    end
  end

  describe "new" do
    it "can get the form" do
      # Act
      get new_driver_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new driver" do
      expect {
        # Act
        post drivers_path params: driver_hash

        # Assert
        must_respond_with :redirect
      }.must_change "Driver.count", 1
    end

    it "will not create an invalid driver" do
      # Arrange
      driver_hash[:driver][:name] = nil

      expect {
        # Act
        post drivers_path params: driver_hash

        # Assert
        must_respond_with :redirect
      }.wont_change "Driver.count"
    end
  end

  describe "destroy" do
    it "will destroy an existing driver" do
      # Arrange
      driver = Driver.first

      expect {
        # Act
        delete driver_path(driver.id)

        # Assert
        must_respond_with :redirect
      }.must_change "Driver.count", -1
    end

    it "will respond with a redirect when given an invalid driver" do
      expect {
        # Act
        delete driver_path(-1)

        # Asert
        must_respond_with :redirect
      }.wont_change "Driver.count"
    end
  end
end
