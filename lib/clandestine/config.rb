module Clandestine
  module Config
    CONFIG_PATH = "#{ENV['HOME']}/.pswds"
    
    def change_safe_location(new_location)
      if new_location
        FileUtils.mkpath File.dirname new_location unless Dir.exists? File.dirname new_location
        old_file = File.readlink CONFIG_PATH if File.symlink? CONFIG_PATH
        if IO.readlines(CONFIG_PATH).empty? 
          File.new new_location, 'w' unless File.exists? new_location
        else 
          FileUtils.copy_file(CONFIG_PATH, new_location, true) unless File.exists? new_location
        end
        FileUtils.ln_s(new_location, CONFIG_PATH, :force => true)
        FileUtils.rm_f old_file if old_file
      else
        if File.symlink? CONFIG_PATH
          puts "Current safe location is #{File.readlink CONFIG_PATH}"
        else
          puts "Current safe location is #{CONFIG_PATH}"
        end
      end
    end
  end
end
