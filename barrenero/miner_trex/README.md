# Barrenero Miner TREX
Tools and scripts for mining crypto currencies.

* **Version**: 1.0.0
* **Status**: Production/Stable
* **Author**: José Antonio Perdiguero López

This projects aims to create a platform that provides an easy way of adding miners for different cryptocurrencies,
isolating each miner into a docker container, easy to build, update and independent of the system.

Miners currently supported:

* [T-Rex](https://github.com/trexminer/T-Rex/).

Full [documentation](http://barrenero.readthedocs.io) for Barrenero project.

## Help us Donating
This project is free and open sourced, you can use it, spread the word, contribute to the codebase and help us donating:

* **Ether**: `0x566d41b925ed1d9f643748d652f4e66593cba9c9`
* **Bitcoin**: `1Jtj2m65DN2UsUzxXhr355x38T6pPGhqiA`
* **PayPal**: `barrenerobot@gmail.com`

## Requirements
* Docker. [Official docs](https://docs.docker.com/engine/installation/).
* Nvidia Docker. Follow instructions [here](https://github.com/NVIDIA/nvidia-docker).

## Quick start
* Run miner: `docker run perdy/barrenero-miner-trex:latest -c config.json`
