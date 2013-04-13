require 'spec_helper'

describe Clandestine::Guard do
  before :each do
    Clandestine::Guard.instance_eval do
      attr_accessor :safe, :command, :arg
    end
    @guard = Clandestine::Guard.new mock("safe")
    ARGV.clear
  end
  it "should validate 0 args" do
    @guard.validate_args.should eql false
  end
  it "should validate 1 arg" do
    ARGV << "-g"
    @guard.validate_args.should eql true
  end
  it "should validate > 1 and < 3 args" do
    ARGV << "-g" << "keys"
    @guard.validate_args.should eql true
  end
  it "should validate >= 3 args" do
    ARGV << "-g" << "all" << "too many"
    @guard.validate_args.should eql false
  end
  it "should process input after validating args" do
    @guard.stub(:validate_args).and_return true
    @guard.should_receive(:validate_args)
    @guard.should_receive(:process_input)
    @guard.on_the_job
  end
  it "should print options if no args are provided" do
    @guard.stub(:validate_args).and_return false
    @guard.should_receive(:print_options)
    @guard.on_the_job
  end
  it "should process the -a switch to add a key and value" do
    @guard.stub(:ask).and_return("safepassword", "gmailpassword")
    @guard.stub(:add_data).with("gmail:gmailpassword", "safepassword").and_return "Successfully added key value pair"
    @guard.command = "-a"
    @guard.arg = "gmail"
    @guard.process_input.should eql "Successfully added key value pair" 
  end
  it "should process the -g switch with no argument" do
    @guard.stub(:ask).and_return "safepassword"
    @guard.stub(:retrieve_data).with("safepassword").and_return nil
    @guard.safe.should_receive(:empty?).and_return true
    $stdout.should_receive(:puts).with("The safe is empty")
    @guard.command = "-g"
    @guard.process_input
  end
  it "should process the -g switch with an argument" do
    @guard.safe.stub(:empty?).and_return false
    @guard.stub(:ask).and_return "safepassword"
    @guard.stub(:retrieve_data).with("safepassword").and_return Hash["gmail" => "gmailpassword"]
    IO.should_receive(:popen).with('pbcopy', 'w')
    @guard.should_receive(:sleep).with(5)
    IO.should_receive(:popen).with('pbcopy', 'w')
    @guard.command = "-g"
    @guard.arg = "gmail"
    @guard.process_input
  end
  it "should process the -d switch with an argument" do
    @guard.safe.stub(:empty?).and_return false
    @guard.stub(:remove_key_value).with("safepassword")
    @guard.stub(:ask).and_return "safepassword"
    @guard.should_receive(:ask).with("Enter the password for the safe")
    @guard.should_receive(:remove_key_value).with("safepassword")
    @guard.command = "-d"
    @guard.arg = "gmail"
    @guard.process_input
  end
  it "should process the -d switch with no argument" do
    @guard.safe.stub(:empty?).and_return false
    @guard.should_receive(:empty_safe)
    @guard.command = "-d"
    @guard.arg = nil
    @guard.process_input
  end
  it "should process the -l switch with a path as an argument" do
    @guard.command = "-l"
    @guard.arg = "~/.new_safe"
    @guard.should_receive(:change_safe_location).with("~/.new_safe")
    @guard.process_input
  end
  it "should process the -c switch" do
    @guard.command = "-c"
    @guard.should_receive(:change_safe_password)
    @guard.process_input
  end
  it "should process the -r switch" do
    @guard.command = "-r"
    @guard.should_receive(:remove_safe)
    @guard.process_input
  end
  it "should add data to safe" do
    @guard.stub(:retrieve_data).with("fakepassword").and_return nil
    @guard.safe.stub(:lock).with("gmail:gmailpassword\n", "fakepassword")
    $stdout.should_receive(:puts).with("Successfully added key value pair")
    @guard.add_data "gmail:gmailpassword", "fakepassword"
  end
  it "should retreive data froms safe" do
    @guard.safe.stub(:unlock).with("safepassword").and_return("gmail:gmailpassword")
    @guard.retrieve_data("safepassword").should eql Hash["gmail" => "gmailpassword"]
  end
  it "should empty the safe" do 
    STDIN.stub(:gets).and_return("Y")
    @guard.safe.stub(:empty?).and_return false
    $stdout.should_receive(:puts).with("Are you sure? (y|Y)")
    @guard.safe.should_receive(:empty_safe)
    $stdout.should_receive(:puts).with("Safe was emptied!")
    @guard.empty_safe
  end
  it "should remove key value from safe" do
    @guard.stub(:retrieve_data).with("safepassword").and_return Hash["gmail" => "gmailpassword", "facebook" => "facebookpassword"]
    $stdout.should_receive(:puts).with("Deleting gmail and related password")
    @guard.safe.should_receive(:lock).with("facebook:facebookpassword\n", "safepassword")
    @guard.arg = "gmail"
    @guard.remove_key_value "safepassword"
  end
  it "should remove the safe" do
    @guard.safe.stub(:self_destruct)
    @guard.safe.should_receive(:self_destruct)
    $stdout.should_receive(:puts).with("The safe has been removed!")
    @guard.remove_safe
  end
end
