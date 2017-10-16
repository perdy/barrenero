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

Installation
============

1. Install services:

    .. code:: console

        sudo ./make install

2. Configure barrenero services as explained :doc:`here <configuration>`.

3. Build services:

    .. code:: console

        sudo ./make build

4. Reboot or restart barrenero:

    .. code:: console

        sudo ./make restart

Update
======

1. Update services:

    .. code:: console

        sudo ./make update

2. Build services:

    .. code:: console

        sudo ./make build --no-cache

2. Reboot or restart barrenero:

    .. code:: console

        sudo ./make restart
