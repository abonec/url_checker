require 'url_checker/queue_manager/queue_worker'
module UrlChecker
  module QueueManager
    QUEUE = EM::Queue.new
    WORKERS_COUNT = 10
    module_function
    def add_to_queue(worker)
      QUEUE.push worker
    end
    def start_queue_workers
      WORKERS_COUNT.times do
        EM.defer do
          QueueWorker.new(QUEUE).start
        end
      end
    end
  end
end