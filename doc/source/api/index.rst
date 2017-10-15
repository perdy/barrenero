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

API
===

.. toctree::
   :maxdepth: 2
   :caption: Contents

   Installation<installation.rst>
   Configuration<configuration.rst>
   API Resources<resources.rst>

Overview
--------

API code can be found in this `repository <https://github.com/PeRDy/barrenero-api>`_.

This service defines a lightweight REST API on top of Barrenero Miner, providing an easy and simple way to interact
with all miners. This API exposes methods for:

* Query current machine status, such as active services, GPU stats...
* Query Ether miner and pool status.
* Restart Ether miner service.
* Query Storj miner status.
* Restart Storj miner service.
* Query Ethereum wallet value and last transactions.
