require 'url_checker/web_server/request'
module UrlChecker
  class WebServer < EM::Connection
    include EM::HttpServer

    def post_init
      super
    end

    def process_http_request
      response = Request.new(action, params).process
      send_response response
    rescue Request::Error => e
      send_response(e.as_json)
    rescue Exception => e
      send_response({error: :system, message: e.message, backtrace: e.backtrace})
    end

    def action
      @http_path_info[/\/(\w+)/,1]
    end

    def params
      parse_query(@http_query_string).
          merge(parse_query(@http_post_content)).
          with_indifferent_access
    end

    def send_response(content, status: 200)
      content = content.to_json if content.respond_to? :to_json
      response = EM::DelegatedHttpResponse.new(self)
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.status = status
      response.content_type 'application/json'
      response.content = content
      response.send_response
    end

    def parse_query(query)
      ::Rack::Utils.parse_nested_query query
    end
  end
end