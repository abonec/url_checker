module UrlChecker
  module WebServer
    class Request
      module Actions
        def add_url
          UrlChecker.add_url params[:url]
        end
        def actions
          @actions ||= Actions.instance_methods(false).
              reject{|method_name|method_name == :actions}.
              map(&:to_s)
        end
      end
    end
  end
end