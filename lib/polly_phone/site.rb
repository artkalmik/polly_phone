#encoding: utf-8

require "yaml"
require "nokogiri"
require "open-uri"

module PollyPhone
  class Site

    include Utils

    attr_accessor :main_url

    DEFAULT_DESCRIPTION_TYPE = "Description"
    
    # Create object with configuration for parsing with following params
    # @name - title of web-site we want to parse
    # @main_url - main url of web-site we want to parse
    # @brands_url - additional path to catalog page where we want to get rand names
    # @brand_link_path - path for Nokogiri search method to find element with href param for brand
    # @brand_name_item - path for Nokogiri at_xpath method to find element with name of brand
    #                    (only use when brand name is within another element, otherwise get name of brand link element)
    # @brand_source - only use when we need another element param to find brand content, f.e. 'alt'
    #                 (otherwise use element content) 
    # @model_link_path - path for Nokogiri search method to find element with href param for model
    # @model_image_item - path for Nokogiri at_xpath method to find element with src param for model image
    # @model_name_item - path for Nokogiri at_xpath method to find element with content for model name
    # @spec_path - path for Nokogiri at_xpath method to find container with phone description
    # @spec_type_item - path for Nokogiri at_xpath method to find description type within the container 
    # @spec_category_item - path for Nokogiri at method to find description category within the container
    # @spec_body_item - path for Nokogiri at method to find description text within the container
    # @search_page - additional path for main url for web-site search
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

    def brands_list
      brands.to_h.keys
    end

    def models(brand)
      phone_info(@main_url + brands.to_h[brand])
    end

    def models_list(brand)
      models(brand).map{ |m| m[:name] }
    end

    def search(string)
      phone_info(@main_url + @search_page + string)
    end

    # @return [Array]
    def phone_info(url)
      doc = Nokogiri::HTML(open(url))
      phones = page_parser(doc)
      while doc.at(@next_page)
        next_page_link = @main_url + doc.at(@next_page)["href"]
        doc = Nokogiri::HTML(open(next_page_link))
        phones += page_parser(doc)
      end
      phones
    end
 
    # @return [Array]
    def page_parser(doc)
      doc.search(@model_link_path).map do |item|
        item.css('br').each{ |br| br.replace " " }
        { name: item.at_xpath(@model_name_item).content,
          img:  item.at_xpath(@model_image_item)['src'],
          short: item.at_xpath(@model_image_item)['title'],
          link: item["href"] }
      end
    end
    
    # @return [Hash]
    def phone_desc(url)
      type = DEFAULT_DESCRIPTION_TYPE
      desc = {}
      doc = Nokogiri::HTML(open(@main_url + url))
      doc.search(@spec_path).each do |item|
        item_name = item.at_xpath(@spec_type_item)
        type = item_name ? item_name.content : type
        desc[type] ||= {} 
        category = item.at(@spec_category_item)
        body = item.at(@spec_body_item)
        desc[type][category.content] = body.content if category && body
      end
      desc
    end
  end
end
