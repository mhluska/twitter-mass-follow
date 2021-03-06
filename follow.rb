require 'twitter'
require 'dotenv'

Dotenv.load

RETRIES           = 3
SLEEP_TIME        = 60
USERNAME_FILENAME = '.username'
silent            = ARGV.include?('--silent') || ARGV.include?('-s')

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

# See http://stackoverflow.com/a/9020844
def retryable(options = {})
  opts = { :tries => 1, :on => Exception }.merge(options)

  retry_exception, retries = opts[:on], opts[:tries]

  begin
    return yield
  rescue retry_exception
    if (retries -= 1) > 0
      sleep SLEEP_TIME
      retry
    else
      raise
    end
  end
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
end

urls = File.readlines('follow.txt').map(&:strip)

if File.exist? USERNAME_FILENAME
  last_url       = File.read(USERNAME_FILENAME)
  last_url_index = urls.index(last_url)
  urls           = urls[(last_url_index + 1)..-1]
end

urls.each do |line|
  username = line.split('/').pop

  begin
    retryable(tries: RETRIES, on: Twitter::Error) do
      client.follow(username)
    end
  rescue
    puts "Failed to follow @#{username} after #{RETRIES} retries."
  else
    puts "Followed @#{username}" unless silent
    File.write(USERNAME_FILENAME, line)
  end

  # Avoid rate limit issues with Twitter API.
  if silent
    sleep SLEEP_TIME
  else
    print "Pausing for #{SLEEP_TIME} seconds "
    show_wait_cursor(SLEEP_TIME)
    print "\n"
  end
end
