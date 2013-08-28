# PmsGatewayClient

PMS gateway client

## Installation

Add this line to your application's Gemfile:

    gem 'pms_gateway_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pms_gateway_client

## Usage

```ruby
require 'rubygems'
require 'pms_gateway_client'

url = "http://localhost:9393"
pgc = PmsGatewayClient.new(url)
p pgc.inquiry( "411", "PMS123", 10001)
p pgc.post( "311", "PMS123", "June Cleaver", 1, 10001, 23.95, 9999, 1)

puts pgc.status # status of the call
puts pgc.called_url # the url that was constructed
puts pgc.body_str # the body of the call
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
