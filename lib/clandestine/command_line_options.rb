module Clandestine
  class CommandLineOptions

    attr_reader :parser
    attr_accessor :options
    private :options

    def initialize
      @options = {}
      @parser = OptionParser.new
    end

    def parse
      parser.banner = "Clandestine v#{Clandestine::VERSION}\nUsage: clandestine [option] [key]\n\n"

      parser.on('-a', '--add <key>', 'Add password for <key>') do |key|
        options[:add] = key
      end

      parser.on('-g', '--get [key]', 'Get password for [key] (Returns all keys if key isn\'t given)') do |key|
        options[:get] = key
      end

      parser.on('-d', '--delete <key>', 'Delete <key> and related password') do |key|
        options[:delete] = key
      end

      parser.on('-u', '--update [key]', 'Update password for [key] (Updates password for safe if key isn\'t given)') do |key|
        options[:update] = key
      end

      parser.on '-l', '--location', 'Print location of safe (Default is ~/.cls if env variable CLANDESTINE_SAFE isn\'t set)' do
        options[:location] = nil
      end

      parser.on '-r', '--remove', 'Remove safe completely' do
        options[:remove] = nil
      end

      parser.on '-v', '--version', 'Print version number' do |h|
        options[:version] = nil
      end

      parser.on_tail '-h', '--help', 'Print these options' do |h|
        options[:help] = parser
      end

      parser.parse!
      options
    end
  end
end
