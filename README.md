twitter-mass-follow
===================

Follow a list of Twitter profile URLs

I used this to follow 150+ Bitcoin-related Twitter users from http://blog.coingecko.com/top-cryptocurrency-people-to-follow/.

1. I first retrieve the list using this JavaScript in the console:
```
	document.querySelectorAll('a[href^="https://twitter.com/"]').map(function (item){ return item.href; }).join('\n');
```

2. Copy-paste into the file `follow.txt`

3. Make an app on https://apps.twitter.com/. Add the relevant keys to `.env` like so:

```
TWITTER_CONSUMER_KEY=<key>
TWITTER_CONSUMER_SECRET=<secret>
TWITTER_ACCESS_TOKEN=<token>
TWITTER_ACCESS_SECRET=<secret>
```

4. Run the script with `bundle exec ruby follow.rb`. Or run it in the background
   with `bundle exec ruby follow.rb --silent &`.