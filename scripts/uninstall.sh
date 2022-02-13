#!/usr/bin/env bash

function install()
{
  echo "Uninstall Barrenero..."
  sudo poetry run python . uninstall "$@"
}

install "$@"