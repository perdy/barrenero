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

1. Register a new telegram bot following `these instructions <https://core.telegram.org/bots#creating-a-new-bot>`_ and save the token to use it when installing.

2. Install services:

    .. code:: console

        sudo ./make install --path=/usr/local/lib/barrenero <token_from_previous_step>

3. Move to installation folder:

    .. code:: console

        cd /usr/local/lib/barrenero/barrenero-telegram/

4. (Optional) Configure parameters in *setup.cfg* file.

5. Build the service:

    .. code:: console

        ./make build

6. Reboot or restart Systemd unit:

    .. code:: console

        sudo service barrenero_telegram restart

7. Add the bot to your Telegram chat and configure it using `/start` command.

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
