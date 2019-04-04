module PassengersHelper
  def passenger_trip_action_button(passenger)
    return unless passenger.current_trip

    form_tag complete_trip_passenger_path(passenger) do
      concat label_tag 'rating'
      concat number_field_tag 'rating', nil, within: 1..5
      concat submit_tag 'Rate your trip', data: { disable_with: 'Submitting...' }, class: 'button success'
    end
  end
end
