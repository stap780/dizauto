# frozen_string_literal: true

# This module provides a concern to normalize whitespace in model attributes.
module NormalizeDataWhiteSpace
  extend ActiveSupport::Concern

  included do
    before_save :normalize_whitespace

    private

    def normalize_whitespace
      attributes.each do |key, value|
        self[key] = value.squish if value.respond_to?(:squish)
      end
    end
  end

end
