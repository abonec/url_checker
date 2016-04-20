module UrlChecker
  module QueueManager
    class QueueWorker
      def initialize(queue)
        @queue = queue
      end

      def continue
        @queue.pop do |queue_worker|
          check_url queue_worker
        end
        self
      end
      alias start continue

      def check_url(queue_worker)
        request = EM::HttpRequest.new(queue_worker.uri, connect_timeout: 3).get redirects: 1

        request.callback do |client|
          queue_worker.succeed client.response_header.status
          continue
        end
        request.errback do |client|
          queue_worker.fail client.error, client.response_header.status
          continue
        end
      end
    end
  end
end