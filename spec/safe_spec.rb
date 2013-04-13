require 'spec_helper'

describe Clandestine::Safe do
  include Clandestine::Crypt
  before :each do
    @safe = Clandestine::Safe.new "#{ENV['HOME']}/.tmp_pswds"
    Clandestine::Safe.instance_eval do
      attr_reader :safe_location
    end
  end
  after :each do
    @safe.self_destruct
  end
  it "should create a new safe if one doesn't already exist" do
    File.exists?(@safe.safe_location).should eql true
  end
  it "should remove broken sym link of file doesn't exist" do
    FileUtils.ln_s "#{ENV['HOME']}/.doesnt_exist", @safe.safe_location, :force => true
    @safe = Clandestine::Safe.new "#{ENV['HOME']}/.tmp_pswds"
    File.exists?("#{ENV['HOME']}/.doesnt_exist").should eql false
  end
  it "should lock data" do
    data = "gmail:password"
    @safe.lock(data, "password")
    decrypt(IO.readlines(@safe.safe_location).to_s, "password").should eql data
  end
  it "should unlock data" do
    @safe.lock "gmail:password", "password"
    @safe.unlock("password").should eql "gmail:password"
  end
  it "should know if it's empty" do
    @safe.empty?.should eql true
  end
  it "should remove sym link when self destructing" do
    FileUtils.ln_s("#{ENV['HOME']}/.tmp_pswds_lnk", @safe.safe_location, :force => true)
    @safe.self_destruct
    File.exists?("#{ENV['HOME']}/.tmp_pswds_lnk").should eql false
    File.exists?(@safe.safe_location).should eql false
  end
end
