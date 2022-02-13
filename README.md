# Barrenero
A set of services and tools for effective mining cryptocurrencies.

* **Version:** 1.0.0
* **Status:** final
* **Author:** José Antonio Perdiguero López

This projects aims to create a platform to develop and use cryptocurrency miners such as *Ether*, *Storj*... The main 
goal is to provide a flexible and robust set of services and tools for effective mining cryptocurrencies and performs 
real time checks over these miners.

## Help us Donating
This project is free and open sourced, you can use it, spread the word, contribute to the codebase and help us donating:

* **Ether:** `0x04BE4C8b74d2205b5fE2a31Ca18C670765feac7c`
* **ADA:** `addr1qxe963ree0zmdxtqypl7uvhtuvuzlxq6vrzm0lsrfsu53lffcradg5rrhf6q2wsuae4l4hrm8trlk278awztt82j8slsqz8uz5`
* **Bitcoin:** `1Jtj2m65DN2UsUzxXhr355x38T6pPGhqiA`
* **PayPal:** `barrenerobot@gmail.com`

## Requirements
* Python 3.8 or newer. Download [here](https://www.python.org/).
* Docker. [Official docs](https://docs.docker.com/engine/installation/).

## Quick start
### Install
```commandline
make install
```

### Update
```commandline
make update
```

### Uninstall
```commandline
make uninstall
```

## Services

### Barrenero Miner
This service aims to create a platform that provides an easy way of adding miners for different cryptocurrencies,
isolating each miner into a docker container, easy to build, update and independent of the system.

Miners currently supported:

* [TREX](https://github.com/trexminer/T-Rex).

### Nvidia Tuning
A service for fine-tune Nvidia graphic cards, overclocking and undervolting them among other features.
