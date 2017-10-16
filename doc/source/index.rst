..
    Barrenero, a set of services and tools for effective mining cryptocurrencies.
    Copyright (C) 2017  José Antonio Perdiguero López

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.


Welcome to Barrenero's documentation!
=====================================

Overview
--------

A set of services and tools for effective mining cryptocurrencies.

This projects aims to create a platform to develop and use cryptocurrency miners such as Ether, Storj... The main goal
is to provide a flexible and robust set of services and tools for effective mining cryptocurrencies and performs real
time checks over these miners.

Barrenero consists of following services:

Miner
   Tools and scripts for mining cryptocurrencies.
   Code can be found in this `repository <https://github.com/PeRDy/barrenero-miner>`_.

API
   REST API for interacting with Barrenero.
   Code can be found in this `repository <https://github.com/PeRDy/barrenero-api>`_.

Telegram
   Telegram bot for Barrenero that serves information and provides interactive methods through Barrenero API.
   Code can be found in this `repository <https://github.com/PeRDy/barrenero-telegram>`_.


Code repository can be found in `GitHub <https://github.com/PeRDy/barrenero>`_.

Help us Donating
^^^^^^^^^^^^^^^^

This project is free and open sourced, you can use it, spread the word, contribute to the codebase and help us donating:

:Ether: 0x566d41b925ed1d9f643748d652f4e66593cba9c9
:Bitcoin: 1Jtj2m65DN2UsUzxXhr355x38T6pPGhqiA
:PayPal: barrenerobot@gmail.com

Requirements
^^^^^^^^^^^^

* Python 3.5 or newer. Download from official `python site <https://www.python.org/>`_.
* Docker. Install following `docker doc <https://docs.docker.com/engine/installation/>`_.

.. toctree::
   :maxdepth: 1
   :caption: Installation

   Installation<installation.rst>
   Configuration<configuration.rst>
   Contribute<contribute.rst>

.. toctree::
   :maxdepth: 2
   :caption: Services

   Miner<miner/index.rst>
   API<api/index.rst>
   Telegram<telegram/index.rst>

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
