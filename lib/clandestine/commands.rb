require_relative 'version'
require_relative 'clandestine_error'
require_relative 'io'
require_relative 'safe_location'
require_relative 'commands/add'
require_relative 'commands/update'
require_relative 'commands/get'
require_relative 'commands/delete'
require_relative 'commands/remove_safe'

module Clandestine
  module Commands
      def self.add(key, password = nil)
        password = IO.get_password unless password
        Add.new(password, key).add
      end

      def self.get(key = nil, password = nil)
        if key && password.nil?
          password = IO.get_password
        end
        Get.new(password, key).get
      end

      def self.delete(key, password = nil)
        password = IO.get_password unless password
        Delete.new(password, key).delete
      end

      def self.update(key = nil, password = nil)
        password = IO.get_password unless password
        Update.new(password, key).update
      end

      def self.location
        ENV['CLANDESTINE_SAFE'] || SAFE_LOCATION
      end

      def self.remove(password = nil)
        password = IO.get_password unless password
        RemoveSafe.new(password).remove
      end

      def self.version
        Clandestine::VERSION
      end

      def self.help(options)
        options
      end
  end
end
