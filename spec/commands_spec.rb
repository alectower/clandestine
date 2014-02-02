require 'spec_helper'
require 'clandestine/commands'
require 'clandestine/crypt'
require 'clandestine/safe'
require 'bcrypt'
require 'pstore'

module Clandestine
  describe Commands do

    before :each do
      @temp_dir = File.dirname(__FILE__) + "/tmp"
      Dir.mkdir(@temp_dir) unless File.exists? @temp_dir
      ENV['CLANDESTINE_SAFE'] = "#{@temp_dir}/pswds"
      store = PStore.new "#{@temp_dir}/pswds"
      store.transaction do |s|
        s[:safe_password] = BCrypt::Password.create 'password'
        s[:gmail] = Crypt.encrypt 'gmail_password', 'password'
      end
    end

    after :each do
      passwords = "#{@temp_dir}/pswds"
      File.delete passwords if File.exists? passwords
      Dir.rmdir @temp_dir if File.exists? @temp_dir
    end

    describe '.version' do
      it 'prints version' do
        expect(Commands.version).to eq VERSION
      end
    end

    describe '.add' do
      it 'adds key and password to safe' do
        PasswordGenerator.should_receive(:random_password).and_return 'twitter_password'
        Commands.add 'twitter', 'password'
        Safe.new('password').open do |s|
          s[:twitter].should eq 'twitter_password'
        end
      end
    end

    describe '.get' do
      context 'without argument' do
        it 'prints accounts' do
          Commands.get(nil, 'password').should eq [:gmail]
        end
      end

      context 'with argument' do
        it 'gets password for key from safe' do
          IO.should_receive(:get_password).and_return "password"
          Commands.get('gmail').should eq 'gmail_password'
        end
      end
    end

    describe '.delete' do
      context 'with argument' do
        it 'deletes key and password from safe' do
          Commands.delete 'gmail', 'password'
          Safe.new('password').open do |s|
            s.contents.should be_empty
          end
        end
      end
    end

    describe '.update' do
      it 'updates password related to key' do
        PasswordGenerator.should_receive(:random_password).and_return 'updated_password'
        Commands.update 'gmail', 'password'
        Safe.new('password').open do |s|
          s[:gmail].should eq 'updated_password'
        end
      end
    end

    describe '.location' do
      it 'shows current safe location' do
        Commands.location.should eq "#{@temp_dir}/pswds"
      end

      it 'defaults to ENV["HOME"]/.pswds' do
        ENV.delete('CLANDESTINE_SAFE')
        Commands.location.should eq "#{ENV['HOME']}/.cls"
      end
    end

    describe '.remove' do
      it 'removes safe from file system' do
        Commands.remove 'password'
        File.exists?(ENV['CLANDESTINE_SAFE'] = "#{@temp_dir}/pswds").should eq false
      end
    end
  end
end
