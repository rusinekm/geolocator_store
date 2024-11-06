# frozen_string_literal: true

require 'test_helper'

class GeolocationTest < ActiveSupport::TestCase
  test 'should not save geolocation without same ip' do
    Geolocation.create(ip: 'some_ip')
    geolocation2 = Geolocation.new(ip: 'some_ip')
    assert_not geolocation2.save
  end
end
