# frozen_string_literal: true

# Shipping < ApplicationRecord
class Shipping < ApplicationRecord
  belongs_to :order
  audited associated_with: :order
  has_many :comments, as: :commentable
  accepts_nested_attributes_for :comments, allow_destroy: true

end
