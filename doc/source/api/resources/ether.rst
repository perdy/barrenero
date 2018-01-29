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

Ether Miner Status
==================

Retrieve Ether miner status.

Request
-------

URL
^^^

`/api/v1/ether/`

Headers
^^^^^^^

Authorization
    Token <auth_token>

Response
--------

.. code:: javascript

    {
      "status": "active/inactive",
      "hashrate": [
        {
          "graphic_card": int,
          "hashrate": float
        }
      ],
      "nanopool": {
        "balance": {
          "confirmed": float,
          "unconfirmed": float
        },
        "hashrate": {
          "current": float,
          "one_hour": float,
          "three_hours": float,
          "six_hours": float,
          "twelve_hours": float,
          "twenty_four_hours": float
        },
        "workers": [
          {
            "id": string,
            "hashrate": float
          }
        ],
        "last_payment": {
          "date": string,
          "hash": string,
          "value": float,
          "confirmed": bool
        }
      }
    }
