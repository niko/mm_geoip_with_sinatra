require 'sinatra/base'
require 'mm_geoip.rb'
require 'rack_mm_geoip.rb'

class MMGeoip
  def initialize(env)
    @env = env # may be a Rack @env or any hash containing initial data
    @env[:ip] ||= @env["HTTP_X_REAL_IP"] || @env["HTTP_X_FORWARDED_FOR"] || @env["REMOTE_ADDR"]
    
    raise NoIpGiven.new unless @env[:ip]
    
    @geodb = GeoIP.new self.class.db_path
  end
  
  def lookup
    return @lookup if @lookup
    
    looked_up_fields = @geodb.city @env[:ip]
    
    return @lookup = {} unless looked_up_fields
    
    @lookup = Hash[FIELDS.zip looked_up_fields.to_a]
    @lookup[:region_name] = region_name
    @lookup
  end
end

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


