require 'highline/import'

module Clandestine
  class IO
    def self.copy_to_clipboard(value)
      ::IO.popen('pbcopy', 'w') { |b| b.print "#{value}" }
      say("Password on clipboard countdown: ")
      10.downto(1) do |n|
        sleep(1);
        n == 1 ? say("1") : say("#{n} ")
      end
      ::IO.popen('pbcopy', 'w') { |b| b.print "" }
    end

    def self.print_keys(contents)
      puts "-------------"
      puts "Safe Contents"
      puts "-------------"
      contents.sort.each { |key| puts key.to_s }
    end

    def self.get_password(new_password = false)
      message = if new_password
        "Enter the new safe password"
      else
        "Enter the safe password"
      end
      ask(message) { |q| q.echo = "*" }
    end

  end
end
