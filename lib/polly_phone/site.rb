#encoding: utf-8

require "yaml"
require "nokogiri"
require "open-uri"

module PollyPhone
  class Site

    include Utils

    attr_accessor :main_url
    
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

    # @return [Array]
    def brands
      doc = Nokogiri::HTML(open(@main_url + @brands_url))
      doc.search(@brand_link_path).map do |item|
        link = item["href"]
        # if @brand_name_item exist we use another element within container
        item = item.at_xpath(@brand_name_item) if @brand_name_item
        # if @brand_source exist we use another param
        name = @brand_source ? item[@brand_source] : item.content
        [clr_str(name), link]
      end
    end

  end
end
