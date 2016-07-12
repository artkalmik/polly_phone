#encoding: utf-8

require "yaml"
require "nokogiri"
require "open-uri"

module PollyPhone
  class Site

    include Utils

    attr_accessor :main_url

    DEFAULT_DESCRIPTION_TYPE = "Description"
    
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
