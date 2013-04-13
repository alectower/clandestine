require 'highline/import'

module Clandestine
  # Handles user requests and interacts
  # with the Safe class.
  #
  # Main class to interface with user.
  # The Guard protects the safe by 
  # authenticating the user, and making sure
  # data is in the correct format to be
  # held in the safe.
  class Guard
    include Clandestine::Config
    
    # Create new guard object with specified safe.
    # Default safe location is ENV['HOME']/.pswds
    def initialize(safe = Safe.new)
      @safe = safe
    end
  
    # Main method that validates arguments
    # and processes input
    def on_the_job
      validate_args ? process_input : print_options
    end
  
    # Checks for the correct switches to be
    # supplied by user
    def validate_args
      if ARGV.size > 0 && ARGV.size < 3
        @command = ARGV[0]
        @arg = ARGV[1]
        (@command =~ /[(-c)]/ && !@arg.nil?) || (@command =~ /[(-a)(-g)(-l)]/ && @arg.nil?)
      else
        false
      end
    end
  
    # Command line options
    def print_options
      puts "Clandestine v#{Clandestine::VERSION}\
            \nOptions: \
            \n\t-a <key>      ::   add password related to <key> \
            \n\t-g <key>      ::   get password related to <key> \
            \n\t-g            ::   get all keys \
            \n\t-d <key>      ::   delete password related to <key> \
            \n\t-d            ::   delete all passwords \
            \n\t-l            ::   print current location of safe \
            \n\t-l <path>     ::   move safe location to <path> \
            \n\t-c            ::   change password to safe \
            \n\t-r            ::   remove safe completely
            \n\n\tPasswords will be copied to the clipboard for 5 seconds \
            \n\n"
    end
  
    # Case statement for switches
    # Main logic method
    def process_input
      case @command
      when "-a"
        add_value
      when "-g"
        get_value
      when "-d"
        delete_value
      when "-l"
        change_safe_location(@arg)
      when "-c"
        change_safe_password
      when "-r"
        remove_safe
      else
        print_options
      end
    end
    
    # Adds a new value to the safe
    # and binds it to the key provided
    # by the user.
    def add_value
      if @arg
        safe_password = ask("Enter the password for the safe") { |q| q.echo = "*" }
        key_password = ask("Enter the password for #{@arg}") { |q| q.echo = "*" }
        add_data "#{@arg}:#{key_password}", safe_password
      else
        puts "A key is needed in order to store a password"
      end
    end
    
    # Retrieves value from safe
    # that is related to the key
    # entered by the user
    def get_value
      (puts "The safe is empty"; return) if @safe.empty?
      safe_password = ask("Enter the password for the safe") { |q| q.echo = "*" }
      case @arg
      when /^\S+$/
        data = retrieve_data(safe_password)
        value = data[@arg] if data
        if value
          IO.popen('pbcopy', 'w') {|clipboard| clipboard.print "#{value}"}
          sleep(10)
          IO.popen('pbcopy', 'w') {|clipboard| clipboard.print ""}
        else
          puts "No value found for #{@arg}"
        end
      else
        data = retrieve_data safe_password
        if data
          data.each_key { |key| puts key }
        else
          puts "Safe is empty"
        end
      end
    end
    
    # Removes key and value from safe.
    def delete_value
      (puts " The safe is empty"; return) if @safe.empty?
      case @arg
      when /^\S+$/
        safe_password = ask("Enter the password for the safe") { |q| q.echo = "*" }
        remove_key_value safe_password
      when nil
        empty_safe
      end
    end
  
    # First retrieves old data to see if
    # the key already exists in the safe,
    # adds it if not.
    def add_data(key_value, safe_password)
      old_data = retrieve_data safe_password
      if old_data && old_data[@arg]
        puts "#@arg already exists"
        return
      end
      merge_data(old_data, key_value, safe_password)
      puts "Successfully added key value pair"
    end
    
    # Merges new key value pair with old data
    def merge_data(old_data, key_value, safe_password)
      new_data = ''
      old_data.each { |key, value| new_data << "#{key}:#{value}\n" } if old_data
      new_data << "#{key_value}\n" if key_value
      @safe.lock(new_data, safe_password)
    end
  
    # Retrieves data from safe and returns
    # it in a key value hash
    def retrieve_data(safe_password)
      begin
        return if !data = @safe.unlock(safe_password)
        data.split("\n").map {|l| l.split(":")}.map {|k, v| Hash[k => v]}.reduce({}) {|h, i| h.merge i}
      rescue OpenSSL::Cipher::CipherError
        puts "You entered an incorrect password"
        exit(0)
      end
    end
  
    # Prompts user for delete confirmation
    # and empties safe if user entered "Y" or "y". 
    def empty_safe
      (puts "The safe is already empty"; return) if @safe.empty?
      puts "Are you sure? (y|Y)"
      if STDIN.gets =~ /^[yY]{1}$/
        @safe.empty_safe 
        puts "Safe was emptied!"
      else
        puts "Not empyting safe"
      end
    end
  
    # Attempts to remove key and value
    # from safe if it exists.
    # If new_data is empty, it means that
    # there is only one key value in the safe,
    # So the safe needs to be emptied rather
    # re-storing the new information.
    def remove_key_value(safe_password)
      new_data = ''
      old_data = retrieve_data safe_password
      if old_data
        puts "Deleting #@arg and related password"
        old_data.each { |key, value| new_data << "#{key}:#{value}\n" if key !~ /^#@arg$/ }
        if new_data.empty?
          @safe.empty_safe
        else
          @safe.lock(new_data, safe_password) 
        end
      else
        puts "Safe is empty"
      end
    end
    
    # Attempts to change the password for the safe.
    # If the safe is empty, there is no password to be changed.
    def change_safe_password
      (puts "The safe is empty, no password is currently active"; return) if @safe.empty?
      old_safe_password = ask("Enter the old password for the safe") { |q| q.echo = "*" }
      new_safe_password = ask("Enter the new password for the safe") { |q| q.echo = "*" }
      data = retrieve_data old_safe_password
      puts "Successfully changed password" if (merge_data(data, nil, new_safe_password) if data)
    end
    
    # Removes safe from file system
    def remove_safe
      @safe.self_destruct
      puts "The safe has been removed!"
    end
  end
end
