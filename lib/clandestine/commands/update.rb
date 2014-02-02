require_relative '../safe'
require_relative '../io'
require_relative '../password_generator'

module Clandestine
  module Commands
    class Update
      attr_reader :safe_password, :key
      private :safe_password, :key

      def initialize(safe_password, key = nil)
        @safe_password = safe_password
        @key = key.to_sym if key
      end

      def update
        Safe.new(safe_password).open do |safe|
          if key
            if safe[key]
              safe.add(key, PasswordGenerator.random_password)
            else
              false
            end
          else
            new_password = IO.get_password(true).chomp
            safe.update_safe_password(new_password)
          end
        end
      end
    end
  end
end
