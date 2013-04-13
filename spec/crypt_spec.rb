require 'spec_helper'

describe Clandestine::Crypt do
  include Clandestine::Crypt
  it "should encrypt data" do
    encrypt("this is a test",'password').should_not eql "this is a test"
  end
  it "should decrypt data" do
    decrypt(encrypt("this is a test",'password'), 'password').should eql "this is a test"
  end
end
