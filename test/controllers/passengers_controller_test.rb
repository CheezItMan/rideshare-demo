require "test_helper"

describe PassengersController do
  let (:passenger_hash) {
    {
      passenger: {
        name: "MJ",
        phone_number: "972-492-1535",
      },
    }
  }

  describe "index" do
    it "can get index" do
      # Act
      get passengers_path

      # Assert
      must_respond_with :success
    end
  end

  describe "show" do
    it "can get a valid Passenger" do
      # Arrange
      passenger = Passenger.first

      # Act
      get passenger_path(passenger.id)

      # Assert
      must_respond_with :success
    end

    it "will respond with a redirect with an invalid passenger" do
      get passenger_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "edit" do
    it "can get the edit form for a valid passenger" do
      # Arrange
      passenger = Passenger.first

      # Act
      get edit_passenger_path(passenger.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect if trying to edit a passenger that can't be found" do
      # Act
      get edit_passenger_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "update" do
    it "can update an existing passenger" do
      # Arrange
      passenger = Passenger.first

      # Act
      patch passenger_path(passenger.id), params: passenger_hash

      # Assert
      passenger.reload
      passenger_hash[:passenger].keys.each do |key|
        expect(passenger[key]).must_equal passenger_hash[:passenger][key]
      end
    end

    it "will not update a passenger if given invalid data" do
      # Arrange
      passenger = Passenger.first
      old_name = passenger.name
      passenger_hash[:passenger][:name] = nil

      # Act
      patch passenger_path(passenger.id), params: passenger_hash

      # Assert
      must_respond_with :redirect

      passenger.reload
      expect(passenger.name).must_equal old_name
    end
  end

  describe "new" do
    it "can get the form" do
      # Act
      get new_passenger_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new passenger" do
      expect {
        # Act
        post passengers_path params: passenger_hash

        # Assert
        must_respond_with :redirect
      }.must_change "Passenger.count", 1
    end

    it "will not create an invalid passenger" do
      # Arrange
      passenger_hash[:passenger][:name] = nil

      expect {
        # Act
        post passengers_path params: passenger_hash

        # Assert
        must_respond_with :redirect
      }.wont_change "Passenger.count"
    end
  end

  describe "destroy" do
    it "will destroy an existing passenger" do
      # Arrange
      passenger = Passenger.first

      expect {
        # Act
        delete passenger_path(passenger.id)

        # Assert
        must_respond_with :redirect
      }.must_change "Passenger.count", -1
    end

    it "will respond with a redirect when given an invalid passenger" do
      expect {
        # Act
        delete passenger_path(-1)

        # Assert
        must_respond_with :redirect
      }.wont_change "Passenger.count"
    end
  end
end
