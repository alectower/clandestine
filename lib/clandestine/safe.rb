module Clandestine
  # The Safe class interacts with a file (safe),
  # storing, retrieving, or removing data from it.
  class Safe
    include Clandestine::Crypt
    include Clandestine::Config
    
    # Default initialization of safe 
    # in PASSWORD_SAFE location
    def initialize(safe_location = Clandestine::Config::CONFIG_PATH)
      @safe_location = safe_location
      File.new @safe_location, 'w' unless File.exists?(@safe_location) || File.symlink?(@safe_location)
      if File.symlink?(@safe_location) && !File.exists?(File.readlink @safe_location)
        FileUtils.rm_f File.readlink @safe_location
      end
    end
  
    # Empties safe by writing nil to file
    def empty_safe
      if File.exists? @safe_location
        File.open(@safe_location, 'w') { |f| f << nil }
      end
    end
    
    # Checks for contents in safe
    def empty?
      if File.symlink? @safe_location 
        IO.readlines(File.readlink @safe_location).empty? if File.exists? File.readlink @safe_location
      else
        IO.readlines(@safe_location).empty?
      end
    end
  
    # Removes safe from file system
    def self_destruct
      FileUtils.rm_f File.readlink @safe_location if File.symlink? @safe_location
      FileUtils.rm_f @safe_location
    end
  
    # Unlocks the safe by decrypting the data
    # currently in the safe with the specified password
    # If the password is incorrect an OpenSSL::Cipher::CipherError
    # exception is thrown
    def unlock(password)
       decrypt(IO.readlines(@safe_location).join, password) unless File.zero? @safe_location
    end
  
    # Locks the safe by encrypting the data with the
    # specified password
    def lock(data, password)
      File.open(@safe_location, 'w') { |f| f << encrypt(data, password) }
    end
  end
end
