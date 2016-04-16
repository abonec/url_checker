require 'url_checker/server'
require 'url_checker/web_server'
module UrlChecker
  def development?
    true
  end
  module_function :development?
end