module Stockable
  extend ActiveSupport::Concern

  included do
    has_one :stock, as: :stockable
    accepts_nested_attributes_for :stock, allow_destroy: true
  end
end