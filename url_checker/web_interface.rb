require 'url_checker/web_interface/code_reloader'
require 'sinatra/json'
require 'sinatra/reloader'
module UrlChecker
  class WebInterface < Sinatra::Base
    include CodeReloader
    register Sinatra::MultiRoute
    register Sinatra::Reloader
    configure do
      set :threaded, true
      set :root, File.join(File.dirname(__FILE__), 'web_interface')
      set :views, Proc.new { File.join(root, 'views') }
      set :static, true
      set :public_folder, Proc.new { File.join(root, 'public') }
    end

    before do
      reload_code
    end

    get '/dashboard' do
      @workers = UrlChecker.get_workers
      @queue_size = UrlChecker.queue_size
      slim :dashboard, layout: true
    end

    post '/urls' do
      json result: UrlChecker.add_url(params[:url])
    end

    delete '/urls' do
      json result: UrlChecker.stop_worker(params[:id].to_i)
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
