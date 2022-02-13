#!/usr/bin/env bash

function install()
{
  echo "Install requirements..."
  poetry install
  echo "Install Barrenero..."
  sudo poetry run python . install "$@"
}

install "$@"