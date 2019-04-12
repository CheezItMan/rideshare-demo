class TripsController < ApplicationController
  before_action :find_trip, only: [:show, :edit, :destroy, :update]
  before_action :find_passenger, only: [:create]

  def show; end

  def edit; end

  def update
    @trip.date = trip_params[:date]
    @trip.rating = trip_params[:rating]
    @trip.price = trip_params[:price]
    @trip.driver_id = trip_params[:driver_id].to_i
    @trip.passenger_id = trip_params[:passenger_id].to_i

    if @trip.save
      redirect_to passenger_trip_path(@trip.passenger.id, @trip.id)
    else
      render :edit
    end
  end

  def destroy
    if @trip
      @trip.destroy
      if request.referer && !request.referer.include?(passenger_trip_path(@trip.passenger.id, @trip.id))
        redirect_back(fallback_location: passenger_path(@trip.passenger.id))
      else
        redirect_back(fallback_location: passenger_path(@trip.passenger.id))
      end
    end
  end

  def create
    trip = @passenger.request_ride!
    if trip
      redirect_to [@passenger, trip]
    else
      redirect_to @passenger, alert: "Could not find any available drivers"
    end
  rescue RideRequestError => e
    redirect_to @passenger, alert: "Could not start a trip: #{e.message}"
  end

  private

  def find_trip
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      flash[:alert] = "Cannot find the trip"
      redirect_back(fallback_location: root_path)
    end
  end

  def find_passenger
    @passenger = Passenger.find_by(id: params[:passenger_id])

    if @passenger.nil?
      flash[:alert] = "Missing passenger"
      redirect_back(fallback_location: passengers_path)
    end
  end

  def trip_params
    trip = params[:trip]
    params[:trip]["date"] = Date.new trip["date(1i)"].to_i, trip["date(2i)"].to_i, trip["date(3i)"].to_i
    params.require(:trip).permit(:date, :rating, :driver_id, :passenger_id, :price, :rating)
  end
end
