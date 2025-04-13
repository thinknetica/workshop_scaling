#!/bin/sh

set -ex

rails db:create
rails db:migrate

exec rails s -b 0.0.0.0 -p 3000


