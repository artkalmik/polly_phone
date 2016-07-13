# PollyPhone

[ ![Codeship Status for artkalmyk/polly_phone](https://codeship.com/projects/195b0a00-2b6e-0134-368a-06ed2d662211/status?branch=master)](https://codeship.com/projects/163157)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'polly_phone'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install polly_phone

## Usage

To begin with we need a YAML file with following configuration:

| option | example |  description |
| --------|---------|-------|
| name: | "MySite" |  title of web-site we want to parse |
| main_url: |  "http://mysite.com/" |  main url of web-site we want to parse |
| brands_url: | "catalog.html"  |  additional path to catalog page where we want to get rand names |
| brand_link_path: | "ul li a" |  path for Nokogiri search method to find element with href param for brand |
| brand_name_item: |  "./img" |  path for Nokogiri at_xpath method to find element with name of brand (only use when brand name is within another element, otherwise get name of brand link element) |
| brand_source: | "alt"  |  only use when we need another element param to find brand content, f.e. 'alt' (otherwise use element content) |
| model_link_path: | "ul li a" |  path for Nokogiri search method to find element with href param for model |
| model_image_item: |  "./img" |  path for Nokogiri at_xpath method to find element with src param for model image |
| model_name_item: | "./h3"  |  path for Nokogiri at_xpath method to find element with content for model name |
| spec_path: | "#desc div" |  path for Nokogiri at_xpath method to find container with phone description |
| spec_type_item: | "./h2" |  path for Nokogiri at_xpath method to find description type within the container |
| spec_category_item: |  "./h3" |  path for Nokogiri at method to find description category within the container |
| spec_body_item: | "./p"  |  path for Nokogiri at method to find description text within the container |
| search_page: | "search.html?name=" |  additional path for main url for web-site search |

At first initialize a new object
```sh
site = PollyPhone::Site.new("config.yml")
```
##### Getting brands

There are two methods to find brands.
First will return an array of arrays [brand_name, brand_link]

```sh
site = PollyPhone::Site.new("config.yml")
site.brands
```
And the second will return an array of brand names as strings:

```sh
site = PollyPhone::Site.new("config.yml")
site.brands_list
```

##### Getting models

There are also two methods to find models by brand.
First will return an array of hases {name: "Model name", img: "image src link", link: "model link" }

```sh
site = PollyPhone::Site.new("config.yml")
site.models("Asus")
```
And the second will return an array of model names as strings:

```sh
site = PollyPhone::Site.new("config.yml")
site.models_list
```

##### Getting phone description

We can get phone description by phone path. It will return a has {"desription type" => {"category" => "text", "category2" => "text"}}

```sh
site = PollyPhone::Site.new("config.yml")
site.phone_desc("iphone5s.html")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/polly_phone.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

