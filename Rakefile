require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the msfte plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Create models used for testing'
task "test:setup" do
  load "./test/test_helper.rb"
  helper = MsfteTestHelper.new
  helper.create_models
end

desc 'Generate documentation for the msfte plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Msfte'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('README_contrib.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
