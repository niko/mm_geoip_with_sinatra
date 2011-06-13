require 'sinatra'
require 'sinatra/mm_geoip.rb'

puts MMGeoip.db_path

MMGeoip.db_path = 'GeoLiteCity.dat'

puts MMGeoip.db_path

use Rack::MMGeoip         # To stuff the MMGeoip proxy object into the env hash.
helpers Sinatra::MMGeoip  # Only if you want to use the convinient #geoip helper method.

get '/' do
  puts "A request from #{geoip.city} (#{geoip.country_name}) [MMGeoip v#{MMGeoip::VERSION}]"
  haml :index
end

get '/do_nothing' do
  puts "A request from somewhere (some country) [MMGeoip v0.0.0]"
  haml :nothing
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

@@ nothing
%html
  %head
    %title mm_geoip with Sinatra, demonstrating usage in routes and views.
  %body
    %ul
      - [:hostname, :ip, :country_code, :country_code3, :country_name, :country_continent, :region, :city, :postal_code, :lat, :lng, :dma_code, :area_code, :timezone, :region_name].each do |field|
        %li= "#{field}: nothing"

