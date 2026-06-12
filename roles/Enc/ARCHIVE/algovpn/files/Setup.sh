#!/usr/bin/env bash

# Setup Script

# Run this once after cloning the Algo repository.
# For more information: https://github.com/trailofbits/algo

python3 -m virtualenv --python="$(command -v python3)" .env &&
  source .env/bin/activate &&
  python3 -m pip install -U pip virtualenv &&
  python3 -m pip install -r requirements.txt

