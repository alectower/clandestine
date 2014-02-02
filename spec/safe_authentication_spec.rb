require 'spec_helper'
require 'clandestine/safe_authentication'

module Clandestine
  describe SafeAuthentication do
    let(:safe) { double('safe') }

    describe '#authenticate' do
      context 'correct password' do
        it 'yields safe' do
          SafeAuthentication.stub(:authenticated?) { true }
          SafeAuthentication.authenticate(safe, 'password').should eq true
        end
      end

      context 'incorrect password' do
        it 'raises error' do
          SafeAuthentication.stub(:authenticated?) { false }
          error = $stderr
          $stderr = StringIO.new
          expect {
            SafeAuthentication.authenticate(safe, 'password')
          }.to raise_error SystemExit
          $stderr.string.should eq "Invalid password!\n"
          $stderr = error
        end
      end
    end
  end
end
