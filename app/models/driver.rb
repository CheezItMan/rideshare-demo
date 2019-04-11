class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true

  scope :active, -> { where(active: true) }
  scope :available, -> { active }

  def average_rating
    return 0 if self.trips.count == 0

    return self.trips.sum(:rating) / self.trips.count.to_f
  end

  def make_and_model
    "#{car_make} #{car_model}"
  end
end
