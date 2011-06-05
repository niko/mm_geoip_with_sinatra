require 'sinatra/base'
require 'mm_geoip.rb'
require 'rack_mm_geoip.rb'

class MMGeoip
  def initialize(env)
    @env = env # may be a Rack @env or any hash containing initial data
    # @env[:ip] ||= @env["HTTP_X_REAL_IP"] # :ip or "REMOTE_ADDR" should be present
    @env[:ip] ||= @env["REMOTE_ADDR"] # :ip or "REMOTE_ADDR" should be present
    
    raise NoIpGiven.new unless @env[:ip]
    
    @geodb = GeoIP.new self.class.db_path
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
    p request.env
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


