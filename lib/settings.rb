File.expand_path(File.dirname(__FILE__) + '/config_parser')

class Settings
  DEFAULT_SETTINGS_PATH = "resources/default.properties"
  OVERRIDEN_SETTINGS_PATH = "resources/override.properties"
  
  #  configure objects: environment variables, settings from override settings file
  #  and setting by default
  #  parametrs:  default_settins_path = DEFAULT_SETTINGS_PATH, 
  #  overriden_settings_path = OVERRIDEN_SETTINGS_PATH, 
  #  enabled_properties_to_override = ["debug", "show_debug_events"] - these properties can change values after settings initialize. Other properties supposed to be constants
  def initialize(default_settins_path = DEFAULT_SETTINGS_PATH, overriden_settings_path = OVERRIDEN_SETTINGS_PATH, enabled_properties_to_override = ["debug", "show_debug_events"])
    @enabled_properties = enabled_properties_to_override
    @env_properties = ConfigParser.new()
    files = [default_settins_path]
    files << overriden_settings_path if File.exist? overriden_settings_path
    @file_properties = ConfigParser.new(files)
    # define dynamic properties   
    @file_properties.override_value("project_dir", File.expand_path("."))
  end
  
  
  # Try get setting in order:
  #  return environment setting if defined
  #  else return property from file with personal settings
  #  else return property by default
  #  else return nil
  def get_property(property)
    get_compound_value(get_value(property))
  end
  
  def respond_to?(symbol, include_private = false)
    get_property(symbol.to_s).nil?
  end
  
  def method_missing(name, *args)
    name.to_s =~ /=$/ ?  try_override_property(name.to_s.gsub(/=$/, ""), args[0]) : get_property(name.to_s)
  end
  
  
  def try_override_property(property, value)
    override_property(property, value) if @enabled_properties.include?(property)
  end
  
  # return array of all defined properties in format "key=value" 
  def get_all_properties
    properties = []
     (@file_properties.get_params_keys + @env_properties.get_params_keys).uniq.each{|k| properties << "#{k} = #{get_property(k)}"}
    properties
  end
  
  private
  # Override given setting (on personal settings level).
  # If this setting was defined by command line - it has no effect
  def override_property(property, value)
    #    @overriden_properties.override_value(property, value)
    @file_properties.override_value(property, value)
  end
  
  # return values in order: environment variables first,
  # if it does not exist, return variable from file, else return nil
  def get_value(property)
    if @env_properties.get_value(property)
      return @env_properties.get_value(property)
    end
    @file_properties.get_value(property)
  end
  
  #  parse compound setting.
  #  parts of this settings must be defined early
  #  you can define option as option=${another_option_name}/something
  def get_compound_value(value)
    if /\$\{(.*?)\}/.match(value.to_s)
      var = /\$\{(.*?)\}/.match(value.to_s)[1]
      exist_var = get_value var
      raise ArgumentError, "Are you defining this setting '#{var}' before?" if exist_var.nil?
      value["${#{var}}"] = exist_var.to_s if var
      get_compound_value(value)
    end
    value
  end
end
