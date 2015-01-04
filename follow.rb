require 'twitter'
require 'dotenv'

Dotenv.load

SLEEP_TIME = 15
silent     = ARGV.include?('--silent') || ARGV.include?('-s')

# See http://stackoverflow.com/a/10263337
def show_wait_cursor(seconds, fps=10)
  chars = %w[| / - \\]
  delay = 1.0/fps
  (seconds * fps).round.times{ |i|
    print chars[i % chars.length]
    sleep delay
    print "\b"
  }
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
end

File.readlines('follow.txt').each do |line|
  username = line.split('/').pop
  client.follow(username)

  puts "Followed @#{username}" unless silent

  # Avoid rate limit issues with Twitter API.
  if silent
    sleep SLEEP_TIME
  else
    print "Pausing for #{SLEEP_TIME} seconds "
    show_wait_cursor(SLEEP_TIME)
    print "\n"
  end
end
