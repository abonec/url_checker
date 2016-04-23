require 'uri'
require 'url_checker/worker/timed_queue'
module UrlChecker
  class Worker
    attr_reader :uri, :status, :id
    DELAYS = {
        default: 2.minutes,
        start: 0.seconds,
        1 => 1.minutes,
        2 => 30.seconds,
        3 => 15.seconds,
        4 => 10.seconds,
        5 => 1.minute,
        6 => 3.minutes,
        7 => 5.minutes,
    }
    LAST_DELAY = DELAYS.keys.select{|key|key.is_a? Fixnum}.max
    WORKERS = []
    UNCHECKED = :unchecked
    CORRECT = :correct
    ERROR = :error
    TYPES = [UNCHECKED, CORRECT, ERROR]

    @@last_id = 0

    def initialize(url)
      @id = @@last_id = @@last_id + 1
      WORKERS[@id] = self
      @uri = URI.parse url
      @errors_count = 0
      @status = UNCHECKED
      @uptime = 0
      @downtime = 0
    end

    def start
      schedule :start if valid?
      self
    end

    def stop
      @timer.cancel
      WORKERS.delete @id
      @on_stop.call if @on_stop
    end

    def schedule(delay_type)
      delay = get_delay(delay_type)
      @timer = TimedQueue.new self, delay
      @timer.start
    end

    def succeed(status)
      @errors_count = 0
      @status = CORRECT
      @last_status = status
      @on_success.call(self) if @on_success
      add_uptime
      schedule :default
      puts "#{Time.now}: #{url} was ok"
    end

    def fail(status, error)
      @errors_count += 1
      @status = ERROR
      @last_status = status
      @last_error = error
      @on_error.call(self) if @on_error
      add_downtime
      schedule :error
      puts "#{Time.now}: #{url} not reached"
    end

    def valid?
      @uri.scheme == 'http'
    end

    def url
      @uri.to_s.chomp('/')
    end

    def add_uptime
      @uptime += Time.now - @last_check_time if @last_check_time
      @last_check_time = Time.now
    end

    def add_downtime
      @downtime += Time.now - @last_check_time if @last_check_time
      @last_check_time = Time.now
    end

    def sla_uptime
      all_time = @uptime + @downtime
      if all_time == 0
        first_check_uptime = if @status == CORRECT
                               1
                             else
                               0
                             end
        return first_check_uptime
      end
      @uptime.to_f / (@uptime + @downtime)
    end

    def formatted_uptime
      if sla_uptime == 1
        100
      else
        (sla_uptime*100).round(2)
      end
    end

    def get_delay(delay_type)
      delay = DELAYS[delay_type || @errors_count]
      return delay if delay
      DELAYS[LAST_DELAY]
    end

    def on_success(&block); @on_success = block; end
    def on_error(&block);   @on_error   = block; end
    def on_stop(&block);   @on_stop   = block; end


    def self.find(id)
      WORKERS[id]
    end

  end
end