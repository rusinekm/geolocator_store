# frozen_string_literal: true

require 'test_helper'

class GeolocationsControllerTest < ActionDispatch::IntegrationTest
  test 'geolocation#get finds item from the database' do
    Geolocation.create(ip: 'google.com')
    get '/geolocations', params: { ip: 'google.com' }
    assert_response :success
    assert_equal @response.body, Geolocation.find_by(ip: 'google.com').to_json
  end

  test 'geolocation#get returns error when finding nonexistant  item from the database' do
    get '/geolocations', params: { ip: 'google.com' }
    assert_response 404
    assert_equal @response.body, '{"status":404,"error":"geolocation not found in database"}'
  end

  test 'geolocation#create adds new item to the database' do
    VCR.use_cassette('post_example_1') do
      geolocation = Geolocation.find_by(ip: 'google.com')
      refute geolocation

      post '/geolocations', params: { ip: 'google.com' }
      assert_response :created

      geolocation = Geolocation.find_by(ip: 'google.com')
      assert geolocation
    end
  end

  test 'geolocation#create does not add new item to the database if it already exists' do
    Geolocation.create(ip: 'some_ip')
    VCR.use_cassette('post_example_2') do
      post '/geolocations', params: { ip: 'some_ip' }

      assert_equal @response.body, '{"error":"resource with said name already created","status":422}'
      assert_response :unprocessable_entity
    end
  end

  test 'geolocation#create does not add new item to the database if search is errorreous' do
    VCR.use_cassette('post_example_3') do
      post '/geolocations', params: { ip: 'some_ip2' }
      assert_equal @response.body, '{"status":422,"error":"invalid_ip_address"}'
      assert_response :unprocessable_entity
    end
  end

  test 'geolocation#destroy deletes item from the database' do
    Geolocation.create(ip: '2google.2com')
    delete '/geolocations', params: { ip: '2google.2com' }
    assert_response :success
    assert_equal @response.body, '{"status":200,"message":"data succesfully deleted"}'

    geolocation = Geolocation.find_by(ip: '2google.2com')
    refute geolocation
  end
  test 'geolocation#destroyreturns error when trying to delete nonexistant item from the database' do
    delete '/geolocations', params: { ip: '2google.com' }
    assert_response 404
    assert_equal @response.body, '{"status":404,"error":"geolocation not found in database"}'
  end
end
