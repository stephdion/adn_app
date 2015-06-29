#!/bin/bash
USERNAME="ubuntu"
HOST="54.152.26.148"
scp -P 22 Gemfile $USERNAME@$HOST:/home/ubuntu/app/current
scp -P 22 -r db $USERNAME@$HOST:/home/ubuntu/app/current
scp -P 22 -r app/controllers $USERNAME@$HOST:/home/ubuntu/app/current/app
scp -P 22 -r app/assets $USERNAME@$HOST:/home/ubuntu/app/current/app
scp -P 22 -r app/views $USERNAME@$HOST:/home/ubuntu/app/current/app
scp -P 22 -r app/models $USERNAME@$HOST:/home/ubuntu/app/current/app
scp -P 22 -r app/helpers $USERNAME@$HOST:/home/ubuntu/app/current/app
scp -P 22 -r app/mailers $USERNAME@$HOST:/home/ubuntu/app/current/app
scp -P 22 -r public $USERNAME@$HOST:/home/ubuntu/app/current
ssh -p 22 -t $USERNAME@$HOST bash --login -c "'
cd app/current
pwd
sh thin_init.sh stop
rake db:migrate
bundle install
sh thin_init.sh start
'"
