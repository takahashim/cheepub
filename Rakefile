require "bundler/gem_tasks"
require "rake/testtask"
require 'rake/clean'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.options = "--max-diff-target-string-size=100000"
  t.test_files = FileList["test/**/*_test.rb"]
end

CLEAN << ".rblatex_work"

task :default => [:test, :rufo]

desc "Run rufo"
task :rufo do
  ruby "-S rufo **/*.rb"
end
