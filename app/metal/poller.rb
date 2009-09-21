# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class Poller
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/p\/(\w*)/
      begin
        if key = Host.find_by_key($1)
          request = Rack::Request.new(env)
          params = request.params
          Stat.create(params)
        else
          return [401, {"Content-Type" => "text/html"}, ["Who are you?"]]
        end
      ensure
        # Release the connections back to the pool.
        ActiveRecord::Base.clear_active_connections!
      end
      [200, {"Content-Type" => "text/html"}, ["Jah, rastafari!"]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not found"]]
    end
  end
end
