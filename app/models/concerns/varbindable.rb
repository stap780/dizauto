# frozen_string_literal: true

# module Varbindable
module Varbindable
  extend ActiveSupport::Concern

  included do
    has_many :varbind, as: :varbindable
  end
end