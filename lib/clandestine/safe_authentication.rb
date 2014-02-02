require_relative 'crypt'
require_relative 'clandestine_error'

module Clandestine
  class SafeAuthentication

    def self.authenticate(safe, password)
      abort 'Invalid password!' unless authenticated?(safe, password)
      true
    end

    private

    def self.authenticated?(safe, password)
      Crypt.matches(safe[:safe_password], password)
    end
  end
end
