#!/usr/bin/env bash

RUN_PARAMS=(
  "--id=$ID"
  "--gateway=$GATEWAY"
)

echo "Initializing nym-client"
exec nym-client init ${RUN_PARAMS[*]}

echo "Starting nym-client"
exec nym-client run
