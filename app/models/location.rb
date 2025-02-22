# Location < ApplicationRecord
class Location < ApplicationRecord
  belongs_to :placement
  belongs_to :variant
  belongs_to :place
  has_many :comments, as: :commentable
  accepts_nested_attributes_for :comments, allow_destroy: true

end
