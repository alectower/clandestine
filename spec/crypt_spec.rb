require 'spec_helper'
require 'clandestine/crypt'

describe Clandestine::Crypt do

  describe '#encrypt' do
    it 'encrypts data with password' do
      encrypted = Clandestine::Crypt.encrypt("myaccountpassword", "safe_password")
      encrypted.should_not eql "myaccountpassword"
      encrypted.should_not eql nil
    end
  end

  describe '#decrypt' do
    it 'decrypts data with password' do
      decrypted = Clandestine::Crypt.decrypt("OePyNbyDMUbza5zUVor4wWS8Tb5u26FmxGXpC9XENWeMNJYJj1WKJlDOZYxG\nXpSqHSSNaT4dhUsX+T7abgZ1qg==\n", "safe_password")
      decrypted.should eql "myaccountpassword"
    end

    it 'does not decrypt with wrong password' do
      expect {
        Clandestine::Crypt.decrypt("OePyNbyDMUbza5zUVor4wWS8Tb5u26FmxGXpC9XENWeMNJYJj1WKJlDOZYxG\nXpSqHSSNaT4dhUsX+T7abgZ1qg==\n", "wrong_password")
      }.to raise_error Clandestine::ClandestineError
    end
  end
end
