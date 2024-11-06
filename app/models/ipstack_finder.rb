# frozen_string_literal: true

class IpstackFinder
  def self.find_by_ip(ip)
    if ENV['IPSTACK_ACCESS_KEY']
      response = Faraday.get("http://api.ipstack.com/#{ip}?access_key=#{ENV['IPSTACK_ACCESS_KEY']}&fields=latitude,longitude,city,country_name")

      json_body = JSON.parse(response.body)

      return json_body['error']['type'] unless response.body['success'].nil?

      json_body
    else
      puts 'Error to be fixed: add ipstack access key to env'
      :no_ipstack_key
    end
  rescue Faraday::Error => e
    puts "Error to be fixed #{e}"
    :faraday_connection_error
  end
end
