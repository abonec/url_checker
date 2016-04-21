require 'active_support/file_update_checker'
module UrlChecker
  class WebInterface < Sinatra::Base
    module CodeReloader
      RELOAD_PATH = Bundler.root.to_s unless defined? RELOAD_PATH
      EXCEPT_FILES = %w(start_server.rb requirements.rb add_top_500_sites.rb)

      # FileUpdateChecker#initialize files, dirs, block
      @@checker ||= ActiveSupport::FileUpdateChecker.new [], [RELOAD_PATH] do
        silence_warnings do
          Dir["#{RELOAD_PATH}/**/*.rb"].
              reject{ |file| file =~ /#{EXCEPT_FILES.join('|')}/ }.
              each{ |file| load(file) }
        end
      end

      def reload_code(force = false)
        return @@checker.execute if force
        @@checker.execute_if_updated if UrlChecker.development?
      end

    end
  end
end
