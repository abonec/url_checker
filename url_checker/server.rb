module UrlChecker
  module Server

    def run
      EM.run do
        EM.start_server '0.0.0.0', '8080', WebServer
        puts 'server was started'
        EM.error_handler do |error|
          puts error
          puts error.backtrace
        end
        trap('SIGINT'){ EM.defer{binding.pry} }
      end
    end

    module_function :run
  end
end