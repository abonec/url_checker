require 'url_checker/queue_manager/queue_worker'
module UrlChecker
  module QueueManager
    mattr_accessor :queue, :workers
    WORKERS_COUNT = 10
    module_function
    def add_to_queue(worker)
      queue.push worker
    end
    def start_queue_workers
      WORKERS_COUNT.times do
        EM.defer do
          workers.push QueueWorker.new(queue).start
        end
      end
    end

    def queue_size
      queue.size
    end

    def init
      self.queue = EM::Queue.new
      self.workers = []
      start_queue_workers
    end
  end
end