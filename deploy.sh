#!/bin/bash

export MIX_ENV=prod
export PORT=4794
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

mix deps.get
mix compile
(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest

mix ecto.migrate

echo "Starting app..."

mix phx.server
