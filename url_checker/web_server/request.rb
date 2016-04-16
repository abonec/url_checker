require 'url_checker/web_server/request/actions'
require 'url_checker/web_server/request/code_reloader'
require 'url_checker/web_server/request/error'
module UrlChecker
  module WebServer
    class Request
      include Actions
      include CodeReloader

      attr_reader :params
      def initialize(action, params)
        reload_code
        @action = action
        @params = params
        validate
      end

      def process
        __send__ @action
      end

      def validate
        validate_action
      end

      def validate_action
        send_error :invalid_action unless actions.include? @action
      end

      def send_error(error_tag)
        raise Error.new(error_tag)
      end
    end
  end
end