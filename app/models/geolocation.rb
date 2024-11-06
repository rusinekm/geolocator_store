# frozen_string_literal: true

class Geolocation < ApplicationRecord
  validates :ip, uniqueness: true
end
