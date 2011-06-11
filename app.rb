require 'sinatra'
require 'sinatra/mm_geoip.rb'

use Rack::MMGeoip         # To stuff the MMGeoip proxy object into the env hash.
helpers Sinatra::MMGeoip  # Only if you want to use the convinient #geoip helper method.

MMGeoip.db_path = '/Users/niko/projects/mm_geoip/data/GeoLiteCity.dat'

get '/' do
  puts "A request from #{geoip.city} (#{geoip.country_name}) [MMGeoip v#{MMGeoip::VERSION}]"
  haml :index
end

__END__

@@ index
%html
  %head
    %title mm_geoip with Sinatra, demonstrating usage in routes and views.
  %body
    %ul
      - (MMGeoip::FIELDS + [:region_name]).each do |field|
        %li= "#{field}: #{geoip.send field}"

