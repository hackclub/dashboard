require 'octokit'

GITHUB_CLIENT_ID = ENV['GITHUB_CLIENT_ID']
GITHUB_CLIENT_SECRET = ENV['GITHUB_CLIENT_SECRET']

client = Octokit::Client.new

if not GITHUB_CLIENT_ID.nil? or GITHUB_CLIENT_SECRET.nil?
  client = Octokit::Client.new(client_id: GITHUB_CLIENT_ID,
                               client_secret: GITHUB_CLIENT_SECRET)
end

SCHEDULER.every '5s', :first_in => 0 do |job|
  repos = client.repos('hackedu')

  commits = Array.new
  repos.map { |r| commits << client.commits("#{r.owner.login}/#{r.name}") }
  commits.flatten!

  most_recent  = commits.max_by { |c| c.commit.author.date }.commit

  short = { author: most_recent.author.name, message: most_recent.message,
            url: most_recent.url }

  send_event('most_recent_commit', { value: short })
end
