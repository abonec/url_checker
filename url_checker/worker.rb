require 'uri'
module UrlChecker
  class Worker
    DELAYS = {
        default: 2.minutes,
        1 => 1.minutes,
        2 => 30.seconds,
        3 => 15.seconds,
        4 => 10.seconds,
    }
    LAST_DELAY = DELAYS.keys.select{|key|key.is_a? Fixnum}.max
    def initialize(url)
      @uri = URI.parse url
      @errors_count = 0
      schedule :default if valid?
    end

    def cancel
      @timer.cancel
    end

    def schedule(delay_type)
      delay = get_delay(delay_type)
      add_timer delay do
        EM.defer do
          check_url
        end
      end
    end

    def check_url
      request = EM::HttpRequest.new(@uri).get
      request.callback do
        puts "#{url} is ok"
        @status = :ok
        @errors_count = 0
        schedule :default
      end
      request.errback do
        puts "#{url} is bad"
        @status = :error
        @errors_count += 1
        schedule @errors_count
      end
    end

    def valid?
      @uri.scheme == 'http'
    end

    def url
      @uri.to_s.chomp('/')
    end

    def add_timer(delay)
      @timer = EM::Timer.new(delay) do
        yield
      end
    end

    def get_delay(errors_count)
      delay = DELAYS[errors_count]
      return delay if delay
      DELAYS[LAST_DELAY]
    end
  end
end