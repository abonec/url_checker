require 'open-uri'
require 'net/http'
URL = 'https://moz.com/top500/domains/csv'

open(URL).readlines[1..-1].map {|line| line.strip.split(',')[1][/\"(.*)\"/,1].
    chomp('/') }.reject{|domain|domain[/\.cn$/]}.shuffle.first(20).each do |domain|
  uri = URI("http://localhost:8080/urls")
  Net::HTTP.post_form(uri, url: "http://#{domain}")
end

