require 'open-uri'
require 'net/http'
URL = 'https://moz.com/top500/domains/csv'

open(URL).readlines[1..-1].map {|line| line.strip.split(',')[1][/\"(.*)\"/,1].
    chomp('/') }.reject{|domain|domain[/\.cn$/]}.first(500).each do |domain|
  uri = URI("http://localhost:8080/add_url?url=http://#{domain}")
  Net::HTTP.get(uri)
end

