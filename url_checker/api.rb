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

    def get_workers
      workers.map{|type, workers| [type, workers.values]}.to_h
    end

    def queue_size
      QueueManager.queue_size
    end
    def development?
      true
    end
  end
end