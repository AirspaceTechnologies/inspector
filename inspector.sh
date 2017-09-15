#!/bin/bash

home=$(pwd)
app_dir=../turks

cd $app_dir
#git pull origin dev
#bundle install
#rake db:migrate
#rake db:test:prepare
rspec spec -t unstable -f json -o rspec.out 

cd $home
./flake.rb $app_dir/rspec.out
rm $app_dir/rspec.out
