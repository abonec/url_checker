require 'url_checker/server'
require 'url_checker/web_server'
require 'url_checker/worker'
module UrlChecker
  module_function
  mattr_accessor(:workers){Hash.new}
  def add_url(url)
    worker = UrlChecker::Worker.new(url)
    if worker.valid? && !workers[worker.url]
      workers[worker.url] = worker
      :url_added
    else
      if worker.valid?
        worker.cancel
        :url_was_already_added
      else
        :url_is_invalid
      end
    end
  end

  def urls
    workers.map(&:key)
  end
  def development?
    true
  end
end