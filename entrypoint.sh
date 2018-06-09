#!/bin/sh
# Docker start script for ruborobo

ruby /usr/src/ruborobo/docker-setup.rb
ruby /usr/src/ruborobo/bot.rb