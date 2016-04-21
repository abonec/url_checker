require 'url_checker/web_interface/code_reloader'
module UrlChecker
  class WebInterface < Sinatra::Base
    include CodeReloader
    configure do
      set :threaded, true
    end

    before do
      reload_code
    end

    get '/add_url' do
      UrlChecker.add_url params[:url]
    end
    get '/urls' do
      UrlChecker.get_urls
    end

    get '/queue_size' do
      UrlChecker.queue_size.to_s
    end

    class << self
      def init(host, port)
        dispatch = Rack::Builder.app do
          map '/' do
            run WebInterface.new
          end
        end

        Rack::Server.start(
            {
                app: dispatch,
                server: 'thin',
                Host: host,
                Port: port,
                signals: false,
            }
        )
      end
    end
  end
end