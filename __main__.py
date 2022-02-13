#!/usr/bin/env python3
import logging
import os
import shlex
import subprocess
import sys
from functools import wraps

from clinner.command import Type as CommandType
from clinner.command import command
from clinner.inputs import bool_input
from clinner.run import Main

from barrenero.install.installer import Installer

logger = logging.getLogger("cli")

PATH = os.path.realpath(os.path.dirname(__file__))
CONFIG_FILE = os.path.join(PATH, "barrenero.toml")

DONATE_TEXT = """
This project is free and open sourced, you can use it, spread the word, contribute to the codebase and help us donating:
* Ether: 0x04BE4C8b74d2205b5fE2a31Ca18C670765feac7c
* ADA: addr1qxe963ree0zmdxtqypl7uvhtuvuzlxq6vrzm0lsrfsu53lffcradg5rrhf6q2wsuae4l4hrm8trlk278awztt82j8slsqz8uz5
* Bitcoin: 1Jtj2m65DN2UsUzxXhr355x38T6pPGhqiA
* PayPal: barrenerobot@gmail.com
"""


def superuser(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        if not os.geteuid() == 0:
            logger.error("Script must be run as root")
            return -1

        return func(*args, **kwargs)

    return wrapper


def donate(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        result = func(*args, **kwargs)

        logger.info(DONATE_TEXT)

        return result

    return wrapper


@command(command_type=CommandType.PYTHON, parser_opts={"help": "Install Barrenero services"})
@donate
@superuser
def install(*args, **kwargs):
    installer = Installer()

    if os.path.exists(CONFIG_FILE):
        installer.config.load(CONFIG_FILE)
        logger.info("This is your current config:\n%s", installer.config)

    if not os.path.exists(CONFIG_FILE) or bool_input("Do you want to update it?"):
        installer.generate_config()
        logger.info("This is your current config:\n%s", installer.config)
        installer.config.dump(CONFIG_FILE)

    if bool_input("Do you want to proceed with installation?"):
        installer.install()


@command(command_type=CommandType.PYTHON, parser_opts={"help": "Uninstall barrenero"})
@donate
@superuser
def uninstall(*args, **kwargs):
    if not os.path.exists(CONFIG_FILE):
        logger.error("Configuration file not found.")

    installer = Installer()
    installer.config.load(CONFIG_FILE)
    installer.uninstall()


@command(command_type=CommandType.PYTHON, parser_opts={"help": "Update Barrenero services"})
@donate
@superuser
def update(*args, **kwargs):
    if not os.path.exists(CONFIG_FILE):
        logger.error("Configuration file not found.")

    installer = Installer()
    installer.config.load(CONFIG_FILE)
    installer.install()

    subprocess.run(
        shlex.split(f"docker-compose -f {os.path.join(installer.config['shared']['lib'], 'docker-compose.yml')} pull")
    )


if __name__ == "__main__":
    main = Main()
    logger.setLevel(logging.INFO)
    sys.exit(main.run())
