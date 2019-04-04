class DriversController < ApplicationController
  before_action :find_driver, only: [:show, :edit, :destroy, :update,
                                     :activate, :pickup, :dropoff]

  def index
    @drivers = Driver.order(:name).page params[:page]
  end

  def show; end

  def new
    @driver = Driver.new
  end

  def create
    driver = Driver.new(driver_params)

    if driver.save
      redirect_to drivers_path
    else
      flash[:alert] = "Unable to save the driver"
      redirect_back(fallback_location: new_driver_path)
    end
  end

  def edit
  end

  def update
    @driver.name = driver_params[:name]
    @driver.vin = driver_params[:vin]
    @driver.car_make = driver_params[:car_make]
    @driver.car_model = driver_params[:car_model]
    if @driver.save
      redirect_to driver_path(@driver.id)
    else
      flash[:alert] = "Cannot update driver #{@driver.id}"
      redirect_back(fallback_location: driver_path(@driver.id))
    end
  end

  def destroy
    trips = @driver.trips
    trips.each do |trip|
      trip.driver = nil
      trip.destroy
    end

    @driver.destroy
    redirect_to drivers_path
  end

  def activate
    if @driver.toggle!(:active)
      redirect_to driver_path(@driver)
    end
  end

  private

  def find_driver
    @driver = Driver.find_by(id: params[:id])

    if @driver.nil?
      flash[:alert] = "Could not find driver with id #{params[:id]}"
      redirect_to drivers_path
    end
  end

  def driver_params
    params.require(:driver).permit(:name, :vin, :car_make, :car_model)
  end
end
