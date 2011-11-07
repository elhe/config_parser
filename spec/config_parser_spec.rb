require File.dirname(__FILE__) + '/spec_helper'
require 'config_parser'
require 'settings'
module AppSettings
  describe ConfigParser do
    DEFAULT_SETTINGS_PATH = "spec/resources/test_default_settings.properties"
    OVERRIDEN_SETTINGS_PATH = "spec/resources/test_override_settings.properties"
    OPTS = "OPTS"

    before :all do
      @saved_opts = ENV[OPTS]
      @settings = Settings.new(DEFAULT_SETTINGS_PATH, OVERRIDEN_SETTINGS_PATH)
    end

    after :all do
      ENV.delete(OPTS)
      ENV[OPTS] = @saved_opts if @saved_opts and (not @saved_opts.to_s.empty?)
    end

    it "should allow properties with dots in its names" do
      @settings.get_property("name.with.dot").should eql(true)
      @settings.send("name.with.dot").should eql(true)
    end

    it "should load settings from default file" do
      @settings.setting1.should eql(false)
    end

    it "should override settings from default file if it has name 'debug'" do
      value = "true"
      @settings.debug=value
      @settings.debug.should eql(value)
    end

    it "should do nothing if property has another name (not 'debug')" do
      value = "true"
      old_value = @settings.setting1
      @settings.setting1=value
      @settings.setting1.should eql(old_value)
    end

    it "should return value in '' as string with single quotes" do
      @settings.single_quote.should eql("'true'")
    end


    it "should return boolean if setting has boolean type" do
      @settings.setting1.should eql(false)
    end

    it "should return compound settings correctly " do
      log_dir = @settings.log_dir
      @settings.screenshots_dir.should eql("#{log_dir}/screenshots")
    end


    it "should return compound settings correctly if it has more than one links" do
      expected = "123/#{@settings.setting2}/#{@settings.setting1}/abcd"
      @settings.setting_with_two_link.should eql(expected)
    end

    it "should return compound settings correctly if it's parts are override on different levels" do
      expected = "#{@settings.setting_for_override}/abcd"
      @settings.compound_with_override.should eql(expected)
    end

    it "should return compound settings correctly if it's parts are override on different levels and has single backslash in path" do
      expected = "#{@settings.another_dir}/log"
      @settings.another_dir_plus.should eql(expected)
    end


    it "should return project dir correctly" do
      expected = File.expand_path(".")
      @settings.project_dir.should eql(expected)
    end

    it "should return project dir correctly if it is part of compound setting" do
      expected = "#{File.expand_path(".")}/abcd"
      @settings.compound_dir.should eql(expected)
    end

    it "should return raise error if compound setting has undefined link" do
      non_exist_setting_name = "non_exist_setting"
      ENV["test_non_exist_compound"]="${#{non_exist_setting_name}}/abdc"
      error_message = "Are you defining this setting '#{non_exist_setting_name}' before?"
      begin
        @settings.instance_variable_set(:@env_properties, ConfigParser.new())
        lambda { @settings.test_non_exist_compound }.should raise_error(ArgumentError, error_message)
      ensure
        #ENV["test_non_exist_compound"]=""
        @settings.instance_variable_set(:@env_properties, ConfigParser.new())
      end
    end

    it "should return env variable" do
      ENV["new_var"]="abcd"
      @settings.instance_variable_set(:@env_properties, ConfigParser.new())
      @settings.new_var.should eql("abcd")
    end

    it "should return string from compound number variable" do
      ENV["numb_one"]="1"
      ENV["new_var"]="${numb_one}2"
      @settings.instance_variable_set(:@env_properties, ConfigParser.new())
      @settings.new_var.should eql("12")
    end


    it "should override personal and default settings if env variable defined" do
      ENV["screenshots_dir"]="abcd"
      @settings.instance_variable_set(:@env_properties, ConfigParser.new())
      @settings.screenshots_dir.should eql("abcd")
    end

    it "should return compound env variable correctly" do
      ENV["temp"]="C:/abcd"
      ENV["screenshots_dir"] = "${temp}/folder"
      @settings.instance_variable_set(:@env_properties, ConfigParser.new())
      @settings.screenshots_dir.should eql("C:/abcd/folder")
    end

    it "should raise no exception if override setting file not found" do
      lambda { Settings.new(DEFAULT_SETTINGS_PATH, "non_exist_file") }.should_not raise_error(Errno::EACCES)
    end

    it "should raise no exception if default setting file not found" do
      non_exist_file = "non_exist_file"
      error = "Permission denied - #{non_exist_file} is not readable"
      lambda { Settings.new(non_exist_file) }.should raise_error(Errno::EACCES, error)
    end


    it "should raise exception when it gets unamed parameter" do
      message = "Invalid pair: =abcd. Expected: non empty name"
      lambda { ConfigParser.new("spec/resources/test_invalid_settings.properties") }.should raise_error(ArgumentError, message)
    end

    it "should return empty string if it gets empty value" do
      ENV["temp"] = ""
      ENV["abcd"] = "qwerty"
      @settings.instance_variable_set(:@env_properties, ConfigParser.new())
      @settings.temp.should eql("")
    end

  end
end