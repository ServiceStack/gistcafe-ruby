require 'json'
require 'net/http'

RSpec.describe Inspect do

  it "has a version number" do
    expect(Inspect::VERSION).not_to be nil
  end

  it "Does print_dump_table simple list" do
    Inspect.print_dump_table([{ a: 1, b:"foo" },{ a: 2.1, b:"barbar" },{ a: 3.21, b:"bazbazbaz" }])
  end

  it "Does Inspect.print_dump_table org_repos" do
    org_name = "ruby"
    uri = URI.parse("https://api.github.com/orgs/#{org_name}/repos")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE    
    # http.set_debug_output($stderr)
    req = Net::HTTP::Get.new(uri.request_uri)
    req["User-Agent"] = "gist.cafe"
    req["Content-Type"] = "application/json"

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
      } 
    })
  end

end
