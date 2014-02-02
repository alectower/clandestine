require_relative '../safe'
require_relative '../io'

module Clandestine
  module Commands
    class Get

      attr_reader :safe_password, :key
      private :safe_password, :key

      def initialize(safe_password, key)
        @safe_password = safe_password
        @key = key.to_sym if key
      end

      def get
        Safe.new(safe_password).open do |safe|
          if no_key_or_value?(safe)
            safe.contents
          else
            safe[key]
          end
        end
      end

      private

      def no_key_or_value?(safe)
        !key || key_missing?(safe)
      end

      def key_missing?(safe)
        !safe[key]
      end
    end
  end
end
