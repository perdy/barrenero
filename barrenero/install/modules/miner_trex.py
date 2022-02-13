import logging
import os
import shutil
import typing

from clinner.inputs import bool_input, default_input

from barrenero.install.modules.base import Module

if typing.TYPE_CHECKING:
    from config import Config

logger = logging.getLogger("cli")


class MinerTREXModule(Module):
    name = "trex"

    def generate_config(
        self, shared_config: typing.Dict[str, typing.Any]
    ) -> typing.Optional[typing.Dict[str, typing.Any]]:
        """
        Ask for needed parameters and generate this module configuration.

        :param shared_config: Shared configuration across all modules.
        :return: Module configuration.
        """
        config: typing.Optional[typing.Dict[str, typing.Any]] = None

        if bool_input("Do you want to install TREX Miner?"):
            config = {"config": default_input("TREX config file", default="config.json")}

        return config

    def install(self, config: "Config"):
        """Performs the installation."""
        os.makedirs(os.path.join(config["shared"]["config"], "miner", "trex"), exist_ok=True)
        logger.info(
            "Remember to save your TREX config in %s file.",
            os.path.join(config["shared"]["config"], "miner", "trex", config["miner"][self.name]["config"]),
        )

    def uninstall(self, config: "Config"):
        """Uninstall this module."""
        shutil.rmtree(os.path.join(config["shared"]["config"], "miner", "trex"), ignore_errors=True)
