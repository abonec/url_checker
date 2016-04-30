module UrlChecker
  module Api
    def add_url(url)
      puts "adding #{url}"
      worker = UrlChecker::Worker.new(url)
      if worker.valid?
        if add_worker worker
          :url_was_added
        else
          :url_is_already_in_check_list
        end
      else
        :url_is_invalid
      end
    end

    def stop_worker(id)
      worker = Worker.find(id)
      return :worker_not_found unless worker
      worker.stop
      :worker_was_stopped
    end

    def get_workers
      workers.map{|type, workers| workers.values}.flatten
    end

    def queue_size
      QueueManager.queue_size
    end
    def development?
      true
    end
  end
end
