#!/usr/bin/env bash

INIT_PARAMS=(
  "--id=nymph"
  "--layer=1"
  "--host=0.0.0.0"
)

echo "Initializing nym-mixnode"
exec nym-mixnode init ${INIT_PARAMS[*]}

RUN_PARAMS=(
  "--id=nymph"
)

echo "Starting nym-mixnode"
exec nym-mixnode run ${RUN_PARAMS[*]}
