require 'url_checker/web_interface/code_reloader'
module UrlChecker
  class WebInterface < Sinatra::Base
    include CodeReloader
    register Sinatra::MultiRoute
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

    route :get, :post, '/add_url' do
      UrlChecker.add_url params[:url]
      redirect '/dashboard'
    end
    get '/dashboard' do
      @workers = UrlChecker.get_workers
      @queue_size = UrlChecker.queue_size
      slim :dashboard, layout: true
    end

    post '/delete_url' do
      UrlChecker.stop_worker params[:id].to_i
      redirect '/dashboard'
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