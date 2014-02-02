require 'optparse'
require_relative 'command_line_options'
require_relative 'commands'
require_relative 'version'
require_relative 'clandestine_error'
require_relative 'io'

module Clandestine

  class CommandLineRunner

    def self.setup
      safe_path = ENV['CLANDESTINE_SAFE']
      safe_path = ENV['CLANDESTINE_SAFE'] = "#{ENV['HOME']}/.cls" unless safe_path
    end

    def self.run
      clo = CommandLineOptions.new
      options = clo.parse
      setup

      command = options.keys.first
      value = options[command]

      case command
      when :add
        output = run_command(command, value)
        if output
          puts "Successfully added password for #{value}"
        else
          puts "Password already exists for #{value}"
        end
      when :get
        output = run_command(command, value)
        if value && !output.is_a?(Array)
          IO.copy_to_clipboard(output)
        else
          IO.print_keys(output)
        end
      when :update
        output = run_command(command, value)
        if output
          if value
            puts "Password for #{value} has been updated"
          else
            puts "Password for safe has been updated"
          end
        else
          if value
            puts "#{value} does not exist"
          else
            puts "Failed to update safe password"
          end
        end
      when :delete
        if run_command(command, value)
          puts "#{value} has been deleted"
        else
          puts "#{value} does not exist"
        end
      when :remove
        if run_command(command, value)
          puts "Safe has been successfully removed"
        else
          puts "Failed to remve safe"
        end
      when :version
        puts Commands.version
      when :location
        puts Commands.location
      when :help
        puts clo.parser.on_tail
      else
        puts clo.parser.on_tail
      end
      puts
    rescue OptionParser::MissingArgument, OptionParser::InvalidOption
      puts clo.parser.on_tail
    end

    def self.run_command(command, value)
      if command
        if value
          Commands.send(command, value)
        else
          Commands.send(command, nil)
        end
      end
    end

  end
end
