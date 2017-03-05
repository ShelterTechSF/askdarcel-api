#!/bin/sh

set -ex

# Set up fresh db
bundle exec rake db:create db:schema:load linksf:import

bundle exec rails server &
rails_pid=$!
sleep 5  # Make sure server is up before continuing

# Kill Rails process on exit
trap "kill $rails_pid" EXIT

# Hit a page to force Rails to cache the loading of modules, avoiding a timeout
# failure on the first Postman test.
curl -v http://localhost:3000/resources?category_id=1 >/dev/null

newman run -g postman/globals.postman_globals.json postman/AskDarcel%20API.postman_collection.json
newman run -g postman/globals.postman_globals.json postman/AskDarcel%20Admin%20API.postman_collection.json
