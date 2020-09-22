#!/usr/bin/env bash

INIT_PARAMS=(
  "--id=$ID"
  "--gateway=$GATEWAY"
)

echo "Initializing nym-client"
exec nym-client init ${INIT_PARAMS[*]}

echo "Starting nym-client"
exec nym-client run
