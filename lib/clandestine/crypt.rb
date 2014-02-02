require 'base64'
require 'bcrypt'
require_relative 'clandestine_error'

module Clandestine
  module Crypt
    def self.hash_password(password)
      BCrypt::Password.create(password).b
    end

    def self.matches(hash, password)
      BCrypt::Password.new(hash) == password
    end

    def self.encrypt(data, password)
      cipher = aes(:encrypt)
      cipher.iv = iv = cipher.random_iv
      key_len = cipher.key_len
      salt = OpenSSL::Random.random_bytes 16
      cipher.key = key = get_key(password, key_len, salt)
      encrypted = cipher.update(data) << cipher.final
      Base64.encode64 encrypted << salt << iv
    end

    def self.decrypt(data, password)
      data = Base64.decode64 data
      cipher = aes(:decrypt)
      cipher.iv = data.slice! -16..-1
      key_len = cipher.key_len
      salt = data.slice! -16..-1
      cipher.key = get_key(password,key_len, salt)
      cipher.update(data) << cipher.final
    rescue OpenSSL::Cipher::CipherError
      raise ClandestineError, 'Invalid password!'
    end

    private

    def self.aes(type)
      aes = OpenSSL::Cipher.new("AES-256-CBC")
      aes.send type
      aes
    end

    def self.get_key(password, length, salt)
      iter = 20000
      digest = OpenSSL::Digest::SHA256.new
      OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iter, length, digest)
    end

  end
end
