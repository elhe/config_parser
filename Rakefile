require 'rubygems' unless ENV['NO_RUBYGEMS']
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'spec/rake/spectask'
require 'rake/rdoctask'

SUMMARY = "config_parser"
GEM = "config_parser"
GEM_VERSION = "0.1.2"

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
Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rd.rdoc_dir = "doc"
end


desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end


Rake::GemPackageTask.new(spec) do |pkg|
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