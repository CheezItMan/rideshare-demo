class Trip < ApplicationRecord
  belongs_to :passenger
  belongs_to :driver

  validates :price, presence: true, numericality: {greater_than: 0.0}

  scope :ongoing, -> { where(rating: nil) }
end
