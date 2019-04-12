module ApplicationHelper
  def random_profile_pic(model)
    if model.id % 4 == 0
      return image_tag "https://placeimg.com/150/150/people", alt: model.name, class: model.class.to_s
    elsif model.id % 4 == 1
      return image_tag "http://www.placecage.com/150/150", alt: model.name, class: model.class.to_s
    elsif model.id % 4 == 2
      return image_tag "https://placebeard.it/150x150", alt: model.name, class: model.class.to_s
    else
      return image_tag "https://placeimg.com/150/150/people", alt: model.name, class: model.class.to_s
    end
  end
end
