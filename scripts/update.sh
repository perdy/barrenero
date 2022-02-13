#!/usr/bin/env bash

function install()
{
  echo "Update Barrenero..."
  sudo poetry run python . update "$@"
}

install "$@"