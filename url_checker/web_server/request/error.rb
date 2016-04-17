module UrlChecker
  class WebServer < EM::Connection
    class Request
      class Error < StandardError
        attr_reader :tag, :params
        def initialize(tag, params={})
          @tag = tag
          @params = params
          super "#{@tag}#{params if params.present?}"
        end

        def as_json(*)
          params.merge type: :error, error: tag
        end
      end
    end
  end
end
