=========
Barrenero
=========

A set of services and tools for effective mining cryptocurrencies.

:Version: 1.0.0
:Status: final
:Author: José Antonio Perdiguero López

This projects aims to create a platform to develop and use cryptocurrency miners such as Ether, Storj... The main goal
is to provide a flexible and robust set of services and tools for effective mining cryptocurrencies and performs real
time checks over these miners.

Full `documentation <http://barrenero.readthedocs.io>`_ for Barrenero project.

Help us Donating
----------------

This project is free and open sourced, you can use it, spread the word, contribute to the codebase and help us donating:

:Ether: 0x566d41b925ed1d9f643748d652f4e66593cba9c9
:Bitcoin: 1Jtj2m65DN2UsUzxXhr355x38T6pPGhqiA
:PayPal: barrenerobot@gmail.com

Requirements
------------

* Python 3.5 or newer. Download `here <https://www.python.org/>`_.
* Docker. `Official docs <https://docs.docker.com/engine/installation/>`_.

Quick start
-----------

1. Install services:

    .. code:: console

        sudo ./make install

2. Configure barrenero services as explained in `documentation <http://barrenero.readthedocs.io>`_.

3. Build the service:

    .. code:: console

        ./make build

4. Reboot or restart barrenero:

    .. code:: console

        ./make restart

Services
--------

Barrenero Miner
^^^^^^^^^^^^^^^

Miner code can be found in this `repository <https://github.com/PeRDy/barrenero-miner>`_.

This service aims to create a platform that provides an easy way of adding miners for different cryptocurrencies,
isolating each miner into a docker container, easy to build, update and independent of the system.

Miners currently supported:

* Ether (`ethminer <https://github.com/ethereum-mining/ethminer>`_).
* Storj (`storj <https://storj.io/>`_).

Barrenero API
^^^^^^^^^^^^^

API code can be found in this `repository <https://github.com/PeRDy/barrenero-api>`_.

This service defines a lightweight REST API on top of Barrenero Miner, providing an easy and simple way to interact
with all miners. This API exposes methods for:

* Query current machine status, such as active services, GPU stats...
* Query Ether miner and pool status.
* Restart Ether miner service.
* Query Storj miner status.
* Restart Storj miner service.
* Query Ethereum wallet value and last transactions.

Barrenero Telegram
^^^^^^^^^^^^^^^^^^

Telegram code can be found in this `repository <https://github.com/PeRDy/barrenero-telegram>`_.

Telegram bot for Barrenero that serves information and provides interactive methods through Barrenero API.

This bot provides a real time interaction with Barrenero through its API, allowing a simple way to register an user in
the API and link it to a Telegram chat. Once the registration is done, it's possible to query for Barrenero status,
restart services and performs any action allowed in the API.

Barrenero Telegraf
^^^^^^^^^^^^^^^^^^

Telegraf code can be found in this `repository <https://github.com/PeRDy/barrenero-telegraf>`_.

Extension for Barrenero that harvests information and send it using Telegraf.

This extension provides an automatic way of harvesting Barrenero status through its API and send it through Telegraf.
