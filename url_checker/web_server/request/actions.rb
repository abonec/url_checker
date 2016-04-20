module UrlChecker
  class WebServer < EM::Connection
    class Request
      module Actions
        def add_url
          UrlChecker.add_url params[:url]
        end
        def urls
          UrlChecker.get_urls
        end
        def actions
          @actions ||= Actions.instance_methods(false).
              reject{|method_name|method_name == :actions}.
              map(&:to_s)
        end

        def queue_size
          UrlChecker.queue_size
        end
      end
    end
  end
end