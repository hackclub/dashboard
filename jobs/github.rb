require 'octokit'

GITHUB_CLIENT_ID = ENV['GITHUB_CLIENT_ID']
GITHUB_CLIENT_SECRET = ENV['GITHUB_CLIENT_SECRET']

client = Octokit::Client.new

if not GITHUB_CLIENT_ID.empty? or GITHUB_CLIENT_SECRET.empty?
  client = Octokit::Client.new(client_id: GITHUB_CLIENT_ID,
                               client_secret: GITHUB_CLIENT_SECRET)
end

SCHEDULER.every '5s', :first_in => 0 do |job|
  repos = client.repos('hackedu')

  commits = Set.new

  commits.map { |c| puts c }
end
