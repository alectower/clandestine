require_relative '../safe'
require_relative '../io'
require_relative '../password_generator'
require_relative '../clandestine_error'

module Clandestine
  module Commands
    class Add
      attr_reader :safe_password, :key
      private :safe_password, :key

      def initialize(safe_password, key)
        raise ClandestineError.new 'Missing required key argument' unless key
        @safe_password = safe_password
        @key = key.to_sym
      end

      def add
        Safe.new(safe_password).open do |safe|
          if !safe.exists?(key)
            safe.add(key, PasswordGenerator.random_password)
          else
            false
          end
        end
      end
    end
  end
end
