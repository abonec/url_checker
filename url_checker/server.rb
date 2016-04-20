module UrlChecker
  module Server

    def run
      EM.run do
        EM.threadpool_size = 2000
        EM.start_server '0.0.0.0', '8080', WebServer
        puts 'server was started'
        EM.error_handler do |error|
          puts error
          puts error.backtrace
        end
        trap('SIGINT'){ EM.defer{binding.pry} }
        UrlChecker::QueueManager.start_queue_workers
      end
    end

    module_function :run
  end
end