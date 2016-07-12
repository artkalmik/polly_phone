#encoding: utf-8

require "yaml"
require "nokogiri"
require "open-uri"

module PollyPhone
  class Site
    
    def initialize(file_path)
      site_config = symbolize_keys(YAML.load_file(file_path))
      assign_attributes(site_config)
    end

    # set all configuration attributes as instance variables
    def assign_attributes(hash)
      hash.each do |key, value|
        self.instance_variable_set(:"@#{key}", value)
      end
    end

  end
end
