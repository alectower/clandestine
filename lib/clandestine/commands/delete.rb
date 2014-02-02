require_relative '../safe'

module Clandestine
  module Commands
    class Delete
      attr_reader :safe_password, :key
      private :safe_password, :key

      def initialize(safe_password, key)
        @safe_password = safe_password
        @key = key.to_sym
      end

      def delete
        Safe.new(safe_password).open do |safe|
          if safe.exists?(key)
            safe.delete(key)
          else
            false
          end
        end
      end
    end
  end
end
