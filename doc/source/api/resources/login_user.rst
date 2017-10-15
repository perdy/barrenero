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

Login User
==========

Retrieve user token and user given username and password.

Request
-------

URL
^^^

`/api/v1/auth/user`

Parameters
^^^^^^^^^^

Username
    Name to register user

Password
    Password to register user

Response
--------

.. code:: javascript

    {
      "username": string,
      "account": string,
      "is_api_superuser": bool,
      "token": string
    }
