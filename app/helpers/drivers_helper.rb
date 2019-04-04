module DriversHelper
  def driver_activate_button(driver)
    if driver.active?
      text = "Go Offline"
      style = "btn btn-danger"
    else
      text = "Go Online"
      style = "btn btn-primary"
    end

    button_to text, activate_driver_path(driver), method: :post, class: style
  end
end
