# frozen_string_literal: true

class GeolocationsController < ApplicationController
  def show
    geolocation = Geolocation.find_by(ip: params[:ip])
    return render json: { status: 404, error: 'geolocation not found in database' }, status: 404 unless geolocation

    render json: geolocation
  rescue ActiveRecord::ConnectionNotEstablished => e
    puts "Error to be fixed #{e}"
    render json: { error: 'application is unavailable, please try later', status: 503 }, status: 503
  end

  def create
    if Geolocation.find_by(ip: params[:ip])
      render json: { error: 'resource with said name already created', status: 422 }, status: :unprocessable_entity
    else
      ipstack_response = IpstackFinder.find_by_ip(params[:ip])
      case ipstack_response
      when :faraday_connection_error
        render json: { status: 503, error: 'service currently unavailable' }, status: 502

      when :no_ipstack_key
        render json: { status: 503, error: 'service currently unavailable' }, status: 503

      else
        return render json: { status: 422, error: ipstack_response }, status: 422 if ipstack_response.is_a? String

        ipstack_response[:ip] = params[:ip]
        geolocation = Geolocation.new(ipstack_response)
        if geolocation.save
          render json: geolocation, status: :created
        else
          render json: geolocation.errors, status: 422
        end
      end
    end
  end

  def destroy
    geolocation = Geolocation.find_by(ip: params[:ip])
    if geolocation
      geolocation.destroy
      render json: { status: 200, message: 'data succesfully deleted' }, status: 200
    else
      render json: { status: 404, error: 'geolocation not found in database' }, status: 404

    end
  end
end
