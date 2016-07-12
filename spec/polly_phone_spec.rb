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
