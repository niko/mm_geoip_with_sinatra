require 'sinatra/base'
require 'mm_geoip.rb'
require 'rack_mm_geoip.rb'

class App < Sinatra::Base
  enable :inline_templates
  use Rack::MMGeoip
  
  helpers do
    def geoip(field)
      request.env['GEOIP'].send field
    end
  end
  
  get '/' do
    haml :index
  end
end

__END__

@@ index
%html
  %head
    %title mm_geoip with Sinatra
  %body
    %ul
      - (MMGeoip::FIELDS + [:region_name]).each do |field|
        %li= "#{field}: #{geoip field}"


