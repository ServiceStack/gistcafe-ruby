Useful utils for [gist.cafe](https://gist.cafe) Ruby Apps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gistcafe'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install gistcafe

## Usage

Simple Usage Example:

```ruby
require 'json'
require 'net/http'
require 'gistcafe'

org_name = "ruby"
uri = URI.parse("https://api.github.com/orgs/#{org_name}/repos")

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == 'https')
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

req = Net::HTTP::Get.new(uri.request_uri)
req["User-Agent"] = "gist.cafe"

res = http.request(req)
org_repos = JSON.parse(res.body).map {|x| {
    name:        x['name'],
    description: x['description'],
    url:         x['url'],
    lang:        x['language'],
    watchers:    x['watchers'],
    forks:       x['forks']
} }.sort_by { |x| -x[:watchers] }

puts "Top 3 #{org_name} GitHub Repos:"
Inspect.print_dump(org_repos.take(3))

puts "\nTop 10 #{org_name} GitHub Repos:"
Inspect.print_dump_table(org_repos.take(10).map {|x| {
    name:     x[:name],
    lang:     x[:lang],
    watchers: x[:watchers],
    forks:    x[:forks],
}})
```

Which outputs:

```
Top 3 ruby GitHub Repos:
[
    {
        name: ruby,
        description: The Ruby Programming Language [mirror],
        url: https://api.github.com/repos/ruby/ruby,
        lang: Ruby,
        watchers: 17837,
        forks: 4736
    },
    {
        name: www.ruby-lang.org,
        description: Source of the https://www.ruby-lang.org website.,
        url: https://api.github.com/repos/ruby/www.ruby-lang.org,
        lang: Ruby,
        watchers: 787,
        forks: 531
    },
    {
        name: rdoc,
        description: RDoc produces HTML and online documentation for Ruby projects.,
        url: https://api.github.com/repos/ruby/rdoc,
        lang: Ruby,
        watchers: 635,
        forks: 377
    }
]

Top 10 ruby GitHub Repos:
+----------------------------------------------+
|        name        | lang | watchers | forks |
|----------------------------------------------|
| ruby               | Ruby |    17837 |  4736 |
| www.ruby-lang.org  | Ruby |      787 |   531 |
| rdoc               | Ruby |      635 |   377 |
| psych              | C    |      464 |   165 |
| spec               | Ruby |      437 |   353 |
| racc               | Yacc |      435 |    64 |
| iconv              | C    |       48 |    16 |
| mspec              | Ruby |       46 |    60 |
| chkbuild           | Ruby |       38 |    18 |
| docs.ruby-lang.org | Ruby |       34 |    18 |
+----------------------------------------------+
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ServiceStack/gistcafe-ruby.

## License

The gem is available as open source under the terms of the [BSD 2-Clause](https://github.com/ServiceStack/gistcafe-ruby/blob/main/LICENSE).
