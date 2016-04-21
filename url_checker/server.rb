require 'url_checker/web_interface'
module UrlChecker
  module Server

    def run
      EM.run do
        EM.threadpool_size = 100
        WebInterface.init '0.0.0.0', '8080'
        puts 'server was started'
        EM.error_handler do |error|
          puts error
          puts error.backtrace
        end
        trap('SIGINT'){ EM.defer{binding.pry} }
        UrlChecker.init
      end
    end

    module_function :run
  end
end