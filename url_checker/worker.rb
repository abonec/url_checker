require 'uri'
require 'url_checker/worker/timer_checker'
module UrlChecker
  class Worker
    attr_reader :uri
    DELAYS = {
        default: 2.minutes,
        1 => 1.minutes,
        2 => 30.seconds,
        3 => 15.seconds,
        4 => 10.seconds,
    }
    LAST_DELAY = DELAYS.keys.select{|key|key.is_a? Fixnum}.max
    UNCHECKED = :unchecked
    CORRECT = :correct
    ERROR = :error
    TYPES = [UNCHECKED, CORRECT, ERROR]
    def initialize(url)
      @uri = URI.parse url
      @errors_count = 0
      @type = UNCHECKED
    end

    def start
      schedule :default if valid?
      self
    end

    def stop
      @timer.cancel
    end

    def schedule(delay_type)
      delay = get_delay(delay_type)
      @timer = TimerChecker.new self, delay
      @timer.start
      @timer.callback do |status|
        @errors_count = 0
        @status = CORRECT
        @last_status = status
        @on_success.call(self) if @on_success
        schedule :default
      end
      @timer.errback do |status, error|
        @errors_count += 1
        @status = ERROR
        @last_status = status
        @last_error = error
        @on_error.call(self) if @on_error
        schedule :error
      end
    end

    def valid?
      @uri.scheme == 'http'
    end

    def url
      @uri.to_s.chomp('/')
    end

    def get_delay(delay_type)
      return 5.seconds if UrlChecker.development?
      delay = DELAYS[delay_type || @errors_count]
      return delay if delay
      DELAYS[LAST_DELAY]
    end

    def on_success(&block); @on_success = block; end
    def on_error(&block);   @on_error   = block; end

  end
end