module Clandestine
  # This module provides encrypt 
  # and decrypt methods using aes-256-cbc
  module Crypt
  
    def encrypt(data, password)
      Base64.encode64 aes(:encrypt, password, data)
    end
  
    def decrypt(data, password)
      aes(:decrypt, password, Base64.decode64(data))
    end
  
    # Uses AES-256-CBC to encrypt data
    # Key length is 32 bytes
    # IV length is 16 bytes
    # TODO Use random IV and include it in 
    # encrypted data rather than using the same
    # IV every time.
    def aes(mode, password, data)
      sha256 = Digest::SHA2.new
      aes = OpenSSL::Cipher.new("AES-256-CBC")
      aes.send(mode)
      aes.key = sha256.digest(password)
      aes.iv = '0123456789012345'
      '' << aes.update(data) << aes.final
    end
  end
end
