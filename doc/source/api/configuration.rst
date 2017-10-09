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

Configuration
=============

To properly configure Barrenero API you must define the following keys in `.env` file:

Django Secret Key
-----------------
Put the Django secret key in `DJANGO_SECRET_KEY` variable.

More info `here <https://docs.djangoproject.com/en/1.11/ref/settings/#secret-key>`_.

API superuser password
----------------------
To create an API superuser password that allows users to do actions such restarting services you must define a password
and encrypt it using Django tools:

.. code:: python

    from django.contrib.auth.hashers import make_password

    password = make_password('foo_password')

You should put the result in `DJANGO_API_SUPERUSER` variable.

Etherscan token
---------------
Put your Etherscan API token in `DJANGO_ETHERSCAN_TOKEN` variable.

More info `here <https://etherscan.io/apis>`_.

Ethplorer token
---------------
Put your Ethplorer API token in `DJANGO_ETHPLORER_TOKEN` variable.

More info `here <https://github.com/EverexIO/Ethplorer/wiki/Ethplorer-API>`_.
