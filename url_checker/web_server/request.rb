require 'url_checker/web_server/request/actions'
require 'url_checker/web_server/request/code_reloader'
module UrlChecker
  module WebServer
    class Request
      include Actions
      include CodeReloader
      def initialize(action, params)
        reload_code
        @action = action
        @params = params
        validate
      end

      def process
        { action: @action, params: @params }
      end

      def validate
      end
    end
  end
end