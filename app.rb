Bundler.setup
Bundler.require

require 'sinatra/base'
require 'mm_geoip.rb'
require 'rack_mm_geoip.rb'

class App < Sinatra::Base
  use Rack::MMGeoip
  
  get '/' do
    %Q{
      ip: #{request.env['GEOIP'].ip},
      city: #{request.env['GEOIP'].city},
      country_name: #{request.env['GEOIP'].country_name}
    }
  end
end

