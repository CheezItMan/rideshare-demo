class PassengersController < ApplicationController
  before_action :find_passenger, only: [:show, :edit, :destroy, :update, :complete_trip]

  def index
    @passengers = Passenger.order(:name).page params[:page]
  end

  def show
  end

  def new
    @passenger = Passenger.new
  end

  def create
    passenger = Passenger.new(passenger_params)

    if passenger.save
      redirect_to passengers_path
    else
      flash[:alert] = "Unable to create a passenger"
      redirect_back(fallback_location: new_passenger_path)
    end
  end

  def edit
  end

  def update
    @passenger.name = passenger_params[:name]
    @passenger.phone_number = passenger_params[:phone_number]

    if @passenger.save
      redirect_to passenger_path(@passenger.id)
    else
      flash[:alert] = "Unable to update a passenger with id: #{params[:id]}"
      redirect_back(fallback_location: edit_passenger_path(params[:id]))
    end
  end

  def destroy
    @passenger.trips.each do |trip|
      trip.destroy
    end

    @passenger.destroy
    redirect_to passengers_path
  end

  def complete_trip
    redirect_to @passenger, alert: "A trip rating must be provided" unless params[:rating].present?

    @passenger.complete_trip!(params[:rating])
    redirect_to @passenger
  end

  private

  def find_passenger
    @passenger = Passenger.find_by(id: params[:id])

    if @passenger.nil?
      flash[:alert] = "Unable to find passenger with id: #{params[:id]}"
      redirect_to passengers_path
    end
  end

  def passenger_params
    params.require(:passenger).permit(:name, :phone_number)
  end
end
