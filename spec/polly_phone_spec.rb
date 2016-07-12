require 'spec_helper'

RSpec.configure do |c|
  c.include PollyPhone::Utils
end

describe PollyPhone do
  before(:each) do
    @site = PollyPhone::Site.new(File.dirname(__FILE__) + "/fixtures/config.yml")
    @site.main_url = File.dirname(__FILE__) + "/" + @site.main_url
  end

  context "site" do
    it "get brands" do
      brands = @site.brands
      expect(brands.count).to eq 3
      expect(brands.first[0]).to eq "Apple"
      expect(brands.first[1]).to eq "apple.html"
    end

    it "get brands list" do
      brands_list = @site.brands_list
      expect(brands_list.count).to eq 3
      expect(brands_list[0]).to eq "Apple"
      expect(brands_list[1]).to eq "LG"
      expect(brands_list[2]).to eq "Samsung"
    end

    it "get models" do
      models = @site.models("Apple")
      expect(models.count).to eq 3
      expect(models.first[:name]).to eq "IPhone 6"
      expect(models.first[:img]).to eq "test.jpg"
      expect(models.first[:link]).to eq "iphone6.html"
    end

    it "get models list" do
      models_list = @site.models_list("Apple")
      expect(models_list.count).to eq 3
      expect(models_list[0]).to eq "IPhone 6"
      expect(models_list[1]).to eq "IPhone 6s"
      expect(models_list[2]).to eq "IPhone 7"
    end

    it "get phone description" do
      description = @site.phone_desc("iphone6.html")
      expect(description.keys.count).to eq 1
      expect(description["Platform"].keys.count).to eq 3
      expect(description["Platform"]["Chipset"]).to eq "Apple A8"
    end
  end

  context "utils" do
    it "can custom symbolize keys" do
      data = {"one" => 1, "two" => 2}
      hash = symbolize_keys(data)
      expect(hash[:one]).to eq 1
      expect(hash[:two]).to eq 2
    end
  end
end
