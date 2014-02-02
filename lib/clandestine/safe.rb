require 'pstore'
require_relative 'crypt'
require_relative 'safe_authentication'

module Clandestine
  class Safe

    attr_reader :safe, :password, :location
    private :safe, :password, :location

    def initialize(password)
      @password = password
      @location = ENV['CLANDESTINE_SAFE']
      @safe = ::PStore.new(location)
      if first_access(location)
        open do |s|
          safe[:safe_password] = Crypt.hash_password(password)
        end
      end
    end

    def open
      safe.transaction do
        yield self
      end
    end

    def contents
      contents = safe.roots
      contents.delete(:safe_password)
      contents
    end

    def [](key)
      return if !exists?(key)
      SafeAuthentication.authenticate(safe, password)
      value = safe[key]
      Crypt.decrypt(value, password)
    end

    alias :get :[]

    def []=(key, value)
      SafeAuthentication.authenticate(safe, password)
      safe[key] = Crypt.encrypt value, password
      true
    end

    alias :add :[]=

    def delete(key)
      SafeAuthentication.authenticate(safe, password)
      safe.delete(key)
      true
    end

    def update_safe_password(new_password)
      SafeAuthentication.authenticate(safe, password)
      safe[:safe_password] = Crypt.hash_password(new_password)
      true
    end

    def remove
      File.delete location
      true
    end

    def exists?(key)
      SafeAuthentication.authenticate(safe, password)
      !safe[key].nil?
    end

    private

    def first_access(location)
      !File.exists?(location) || ::IO.readlines(location).empty?
    end
  end
end
