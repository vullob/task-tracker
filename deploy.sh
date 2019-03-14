#!/bin/bash

export MIX_ENV=prod
export PORT=4795
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

mix deps.get
mix compile
(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest
mix ecto.create
mix ecto.migrate
mix release
echo "Starting app..."

_build/prod/rel/taskTracker/bin/taskTracker foreground
