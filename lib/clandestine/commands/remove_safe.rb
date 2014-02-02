require_relative '../safe'

module Clandestine
  class RemoveSafe
    attr_reader :safe_password
    private :safe_password

    def initialize(safe_password)
      @safe_password = safe_password
    end

    def remove
      Safe.new(safe_password).open do |safe|
        safe.remove
      end
    end
  end
end
