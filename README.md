twitter-mass-follow
===================

Follow a list of Twitter profile URLs

I used this to follow 100+ Bitcoin-related Twitter users from http://blog.coingecko.com/top-cryptocurrency-people-to-follow/.

- I first retrieve the list using this JavaScript in the console:
```
document.querySelectorAll('a[href^="https://twitter.com/"]').map(function (item){ return item.href; }).join('\n');
```

- Copy-paste into the file `follow.txt`

- Make an app on https://apps.twitter.com/ with read/write permissions. Add the relevant keys to `.env` like so:

```
TWITTER_CONSUMER_KEY=<key>
TWITTER_CONSUMER_SECRET=<secret>
TWITTER_ACCESS_TOKEN=<token>
TWITTER_ACCESS_SECRET=<secret>
```

- Run the script with `$ ruby follow.rb`. Or run it in the background with `$ ruby follow.rb --silent &`.

- Reset `follow.txt` checkpoint with `$ rm .username`


