require 'rubygems' unless ENV['NO_RUBYGEMS']
require 'rubygems/package_task'
require 'rubygems/specification'
require 'date'
require 'rspec/core/rake_task'
require 'rdoc/task'

SUMMARY = "config_parser"
GEM = "config_parser"
GEM_VERSION = "0.1.4"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.author = "Zoya Pavlova"
  s.email = "pavlova.zoya@gmail.com"
  s.homepage = ""
  s.description = s.summary = GEM_VERSION

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  #  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(Rakefile) + Dir.glob("{lib,spec}/**/*")
end

task :default => :spec

desc "Create documentation"
RDoc::Task.new  do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = "doc"
end


desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern ='spec/**/*_spec.rb'
  t.rspec_opts = %w(-fs --color)
end


Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end