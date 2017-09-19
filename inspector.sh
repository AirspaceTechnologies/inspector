#!/bin/bash

home="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
project=$1

while true; do 
  cd $project
  git pull origin dev
  bundle install
  yarn
  bundle exec rake db:test:prepare
  bundle exec spring stop
  RAILS_ENV=test bundle exec rspec spec -f json -o rspec.out
  rm log/test.log && touch log/test.log

  cd $home
  ./inspector.rb $project/rspec.out
  rm $project/rspec.out
  sleep 5
done
