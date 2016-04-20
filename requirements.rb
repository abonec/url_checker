$:.unshift File.dirname(__FILE__)
require 'bundler'
Bundler.require

require 'active_support/core_ext/hash'
require 'active_support/core_ext/module/attribute_accessors'
require 'url_checker'
Bundler.require :development if UrlChecker.development?
