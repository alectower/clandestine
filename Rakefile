#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

namespace :spec do 
  desc 'Run specs for Crypt'
  RSpec::Core::RakeTask.new :crypt do |t|
    t.pattern = 'spec/crypt_spec.rb'
  end
  desc 'Run specs for Safe'
  RSpec::Core::RakeTask.new :safe do |t|
    t.pattern = 'spec/safe_spec.rb'
  end
  desc 'Run specs for Guard'
  RSpec::Core::RakeTask.new :guard do |t|
    t.pattern = 'spec/guard_spec.rb'
  end
  desc 'Rub specs for Config'
  RSpec::Core::RakeTask.new :config do |t|
    t.pattern = 'spec/config_spec.rb'
  end
  task :all => [:safe, :guard, :crypt, :config]
end

task :default => 'spec:all'