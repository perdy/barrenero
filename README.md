# Barrenero
A set of services and tools for effective mining cryptocurrencies.

* **Version:** 1.0.0
* **Status:** final
* **Author:** José Antonio Perdiguero López

This projects aims to create a platform to develop and use cryptocurrency miners such as *Ether*, *Storj*... The main 
goal is to provide a flexible and robust set of services and tools for effective mining cryptocurrencies and performs 
real time checks over these miners.

Full [documentation](http://barrenero.readthedocs.io) for Barrenero project.

## Help us Donating
This project is free and open sourced, you can use it, spread the word, contribute to the codebase and help us donating:

* **Ether:** `0x566d41b925ed1d9f643748d652f4e66593cba9c9`
* **Bitcoin:** `1Jtj2m65DN2UsUzxXhr355x38T6pPGhqiA`
* **PayPal:** `barrenerobot@gmail.com`

## Requirements
* Python 3.5 or newer. Download [here](https://www.python.org/).
* Docker. [Official docs](https://docs.docker.com/engine/installation/).

## Quick start
1. Install services: `sudo ./make install`
2. Configure barrenero services as explained in [documentation](http://barrenero.readthedocs.io).

## Update
1. Update: `sudo ./make update`

## Services

### Barrenero Miner
This service aims to create a platform that provides an easy way of adding miners for different cryptocurrencies,
isolating each miner into a docker container, easy to build, update and independent of the system.

Miners currently supported:

* [Ether](https://github.com/PeRDy/barrenero-miner-ether) based on *ethminer*.
* [Storj](https://github.com/PeRDy/barrenero-miner-storj).

### Barrenero API
API code can be found in this [repository](https://github.com/PeRDy/barrenero-api).

This service defines a lightweight REST API on top of Barrenero Miner, providing an easy and simple way to interact
with all miners. This API exposes methods for:

* Query current machine status, such as active services, GPU stats...
* Query miner service.
* Query pool mining status.
* Restart miner service.
* Query wallet value and last transactions.
* Alert for failing miners.
* Notify for incoming transactions.

### Barrenero Telegram
Telegram code can be found in this [repository](https://github.com/PeRDy/barrenero-telegram).

Telegram bot for Barrenero that serves information and provides interactive methods through Barrenero API.

This bot provides a real time interaction with Barrenero through its API, allowing a simple way to register an user in
the API and link it to a Telegram chat. Once the registration is done, it's possible to query for Barrenero status,
restart services and performs any action allowed in the API.

### Barrenero Telegraf
Telegraf code can be found in this [repository](https://github.com/PeRDy/barrenero-telegraf).

Extension for Barrenero that harvests information and send it using Telegraf.

This extension provides an automatic way of harvesting Barrenero status through its API and send it through Telegraf.
