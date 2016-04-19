module UrlChecker
  class Worker
    class TimerChecker
      include EM::Deferrable
      def initialize(worker, delay)
        @worker = worker
        @delay = delay
      end

      def start
        @timer = EM::Timer.new @delay do
          check_url
        end
        self
      end

      def cancel
        @timer.cancel
      end

      def check_url
        request = EM::HttpRequest.new(@worker.uri, connect_timeout: 3).get redirects: 1

        request.callback do |client|
          succeed client.response_header.status
        end
        request.errback do |client|
          fail client.error, client.response_header.status
        end
      end
    end
  end
end
