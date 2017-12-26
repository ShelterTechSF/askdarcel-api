#!/bin/sh

set -ex

# Set up fresh db
bundle exec rake db:setup db:populate

bundle exec rails server &
rails_pid=$!
sleep 5  # Make sure server is up before continuing

# Kill Rails process on exit
trap "kill $rails_pid" EXIT

# Hit a page to force Rails to cache the loading of modules, avoiding a timeout
# failure on the first Postman test.
curl -v http://localhost:3000/resources?category_id=1 >/dev/null

newman run postman/AskDarcel%20API.postman_collection.json -g postman/globals.postman_globals.json
newman run postman/AskDarcel%20Admin%20API.postman_collection.json -g postman/globals.postman_globals.json
