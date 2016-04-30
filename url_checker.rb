require 'url_checker/server'
require 'url_checker/worker'
require 'url_checker/api'
module UrlChecker
  module_function
  extend Api
  mattr_accessor :workers

  def add_worker(worker)
    return false if in_check_list?(worker)
    workers[:unchecked][worker.url] = worker.start
    worker.on_success do
      workers[:unchecked].delete worker.url
      workers[:bad].delete worker.url
      workers[:good][worker.url] = worker
    end
    worker.on_error do
      workers[:unchecked].delete worker.url
      workers[:good].delete worker.url
      workers[:bad][worker.url] = worker
    end
    worker.on_stop do
      workers[:unchecked].delete worker.url
      workers[:good].delete worker.url
      workers[:bad].delete worker.url
    end
    true
  end

  def in_check_list?(worker)
    workers.values.any?{|type|type[worker.url]}
  end

  def init
    self.workers =
        {
          unchecked: {},
          good: {},
          bad: {},
        }
    Worker.init
    QueueManager.init
  end
end
