require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "headword"
    gem.summary = %Q{When your users are that vain.}
    gem.description = %Q{Simplify adding usernames to your application.}
    gem.email = "jeff@socialrange.org"
    gem.homepage = "http://github.com/jeffrafter/headword"
    gem.authors = ["Jeff Rafter"]
    gem.add_dependency "rsl-stringex", ">= 1.0.2"
    gem.files = FileList["[A-Z]*", "{app,config,generators,lib,rails}/**/*", "test/{controllers,models}/**/*", "test/test_helper.rb"] 
    gem.test_files = FileList["test/{controllers,models}/**/*", "test/test_helper.rb"] 
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test => ["generator:cleanup", "generator:headword"]) do |task|
  task.libs << "lib" << "test"
  task.pattern = "test/**/*_test.rb"
  task.verbose = true
end  

namespace :test do
  Rake::TestTask.new(:clearance => ["generator:cleanup", "generator:clearance", "generator:headword"]) do |task|
    task.libs << "lib" << "test"
    task.pattern = "test/**/*_test.rb"
    task.verbose = true
  end  
end

generators = %w(headword)

namespace :generator do
  desc "Cleans up the test app before running the generator"
  task :cleanup do  
    FileUtils.rm_rf("test/rails")
    system "cd test && rails rails"

    # I don't like testing performance!
    FileUtils.rm_rf("test/rails/test/performance")

    system "echo \"\" >> test/rails/config/environments/test.rb"
    system "echo \"config.gem 'thoughtbot-shoulda', :lib => 'shoulda'\" >> test/rails/config/environments/test.rb"
    system "echo \"config.gem 'thoughtbot-factory_girl', :lib => 'factory_girl'\" >> test/rails/config/environments/test.rb"

    # Make a thing
    system "cd test/rails && ./script/generate scaffold thing name:string mood:string"

    FileUtils.mkdir_p("test/rails/vendor/plugins")
    headword_root = File.expand_path(File.dirname(__FILE__))
    system("ln -s #{headword_root} test/rails/vendor/plugins/headword")
  end
  
  desc "Prepares the application with clearance"
  task :clearance do
    system "echo \"config.gem 'thoughtbot-clearance', :lib => 'clearance'\" >> test/rails/config/environments/test.rb"
    system "echo \"HOST = 'headword'\" >> test/rails/config/environments/test.rb"
    system "echo \"DO_NOT_REPLY = 'donotreply'\" >> test/rails/config/environments/test.rb"
    system "cd test/rails && ./script/generate clearance && rake db:migrate db:test:prepare"
  end
  
  desc "Run the headword generator"
  task :headword do
    system "cd test/rails && ./script/generate headword && rake db:migrate db:test:prepare"
  end
  
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "headword #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('app/**/*.rb')
  rdoc.rdoc_files.include('generators/**/*.rb')
end