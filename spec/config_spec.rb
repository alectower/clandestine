require 'spec_helper'

describe Clandestine::Config do
  include Clandestine::Config
  before :all do
    Clandestine::Config::CONFIG_PATH = "#{ENV['HOME']}/.tstpswds"
    File.new Clandestine::Config::CONFIG_PATH, 'w'
    self.instance_eval do 
      @new_location = "#{ENV['HOME']}/Dropbox/.tstpswds"
      @newer_location = "#{ENV['HOME']}/Dropbox/.tst_pswds"
    end
  end
  after :each do 
    File.delete Clandestine::Config::CONFIG_PATH if File.exists? Clandestine::Config::CONFIG_PATH
    File.delete @new_location if File.exists? @new_location
    File.delete @newer_location if File.exists? @newer_location
  end
  it "should change the location of the password file" do
    change_safe_location @new_location
    File.exists?(@new_location).should eql true
    File.symlink?(Clandestine::Config::CONFIG_PATH).should eql true
  end
  it "should move default safe location contents to a new safe" do
    File.open(Clandestine::Config::CONFIG_PATH, 'a') {|f| f << "stuff"}
    change_safe_location @new_location
    IO.readlines(@new_location).should eql ["stuff"]
    IO.readlines(Clandestine::Config::CONFIG_PATH).should eql ["stuff"]
  end
  it "should move sym linked safe location contents to a new safe" do
    File.open(@new_location, 'a') {|f| f << "stuff"}
    FileUtils.ln_s @new_location, Clandestine::Config::CONFIG_PATH, :force => true
    change_safe_location @newer_location
    IO.readlines(Clandestine::Config::CONFIG_PATH).should eql ["stuff"]
    IO.readlines(@newer_location).should eql ["stuff"]
  end
  it "should delete old safe when moving to a new location" do
    File.open(Clandestine::Config::CONFIG_PATH, 'a') {|f| f << "stuff"}
    change_safe_location @new_location
    change_safe_location @newer_location
    IO.readlines(@newer_location).should eql ["stuff"]
    File.exists?(@new_location).should eql false
  end
  it "should print the current safe location if no argument is supplied" do
    $stdout.should_receive(:puts).with("Current safe location is #{Clandestine::Config::CONFIG_PATH}")
    change_safe_location nil
  end
end
