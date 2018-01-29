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

Barrenero Status
================

Retrieve graphic cards and services status.

Request
-------

URL
^^^

`/api/v1/status/`

Headers
^^^^^^^

Authorization
    Token <auth_token>

Response
--------

.. code:: javascript

    {
      "graphics": [
        {
          "id": int,
          "power": float,
          "fan": int,
          "gpu_usage": int,
          "mem_usage": int,
          "gpu_clock": int,
          "mem_clock": int
        }
      ],
      "services": [
        {
          "name": "Ether",
          "status": "active/inactive"
        },
        {
          "name": "Storj",
          "status": "active/inactive"
        }
      ]
    }
