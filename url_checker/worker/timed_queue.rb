require 'url_checker/queue_manager'
module UrlChecker
  class Worker
    class TimedQueue
      include EM::Deferrable
      def initialize(worker, delay)
        @worker = worker
        @delay = delay
      end

      def start
        @timer = EM::Timer.new @delay do
          add_to_queue
        end
        self
      end

      def add_to_queue
        UrlChecker::QueueManager.add_to_queue @worker
      end

      def cancel
        @timer.cancel
      end

    end
  end
end
