#!/bin/bash

export MIX_ENV=prod
export PORT=4794

echo "Starting app.."
mix phx.server
