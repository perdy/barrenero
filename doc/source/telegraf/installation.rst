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

        sudo ./make install -u <influxdb_username> -p <influxdb_password> <influxdb_url> <influxdb_database>

2. Move to installation folder:

    .. code:: console

        cd /usr/local/lib/barrenero/barrenero-telegraf/

3. Build the service:

    .. code:: console

        ./make build

4. Reboot or restart Systemd unit:

    .. code:: console

        sudo service barrenero_telegraf restart

Systemd
-------

The project provides a service file for Systemd that will be installed. These service files gives a reliable way to run
each miner, as well as overclocking scripts.

To check a miner service status:

.. code:: console

    service barrenero_telegram status

Run manually
------------

As well as using systemd services you can run miners manually using:

.. code:: console

    ./make run
