## About
A gem that provides 3-level configuration (settings from  environment varables, personal settings file and default settings file)

##Installation:
gem install config_parser
(for bundler: gem "config_parser", "0.1.3", :git => "git://github.com/elhe/config_parser.git")

## Build Status
[![Build Status](https://secure.travis-ci.org/elhe/config_parser.png)](http://travis-ci.org/elhe/config_parser)



## Usage

code
 @settings =  AppSettings::Settings.new(File.expand_path('./default.properties'), File.expand_path('./override.properties'))   # create settings object
 @setting.path # get value

or settings singletone
  require 'singleton'
  require 'config_parser'



  class Properties
    include Singleton

    def initialize
      @settings =  AppSettings::Settings.new(File.expand_path('./default.properties'), File.expand_path('./override.properties'))
    end

    def settings
      @settings
    end

  end

  def properties
    Properties.instance.settings
  end


Also you can override or define parameter from command line e.g.
  rake browser=safari

