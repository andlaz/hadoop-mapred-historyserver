require "thor"
require "erb"
require "fileutils"

class Configure < Thor
 
  # ...
  def self.exit_on_failure?
    true
  end 
  
  class << self
    def options(options={})
      
      options.each do |option_name, option_settings|
        option option_name, option_settings  
      end
  
    end
  end
  
  module ERBRenderer
    
    def render_from(template_path)
      ERB.new(File.read(template_path), 0, '<>').result binding
    end
    
  end  
  
  class MapRedHistoryServerConfiguration
    include ERBRenderer
    attr_accessor :hostname
    
  end
  

  desc "historyserver", "Configure the MapRed History Server"
  option :hostname, :required => true
  def historyserver
    
    configuration = MapRedHistoryServerConfiguration.new
    configuration.hostname = options[:hostname]
      
    File.write '/etc/hadoop/mapred-site.xml',
      configuration.render_from('/etc/hadoop/mapred-site.xml.erb')   
    
  end
  
end

Configure.start(ARGV)