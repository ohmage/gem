require 'bundler/gem_tasks'
require 'rubocop/rake_task'

# Style tests. Rubocop
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)
end

desc 'Run all style checks'
task style: ['style:ruby']

desc 'Run all tests on Travis'
task travis: %w(style)

# Default
task default: %w(style)
