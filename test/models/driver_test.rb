require "test_helper"

describe Driver do
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
end
