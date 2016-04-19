module UrlChecker
  module Api
    def add_url(url)
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

    def get_urls
      workers.map{|type, workers| [type, workers.keys.join(',')]}.to_h
    end
    def development?
      true
    end
  end
end