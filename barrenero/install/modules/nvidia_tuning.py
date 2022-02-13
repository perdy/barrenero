import logging
import os
import shutil
import typing

from clinner.inputs import bool_input, default_input

from barrenero.install.modules.base import Module

logger = logging.getLogger("cli")

if typing.TYPE_CHECKING:
    from config import Config

PATH = os.path.realpath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))


class NvidiaTuningModule(Module):
    name = "nvidia"

    def generate_config(
        self, shared_config: typing.Dict[str, typing.Any]
    ) -> typing.Optional[typing.Dict[str, typing.Any]]:
        """
        Ask for needed parameters and generate this module configuration.

        :param shared_config: Shared configuration across all modules.
        :return: Module configuration.
        """
        config: typing.Optional[typing.Dict[str, typing.Any]] = None

        if bool_input("Do you want to install Nvidia Tuning service?"):
            graphic_cards = default_input(
                "Which Nvidia graphics card want to overclock (Bus ID)?", default="0,1,2"
            ).split(",")
            config = {
                "graphic_cards": graphic_cards,
                "compute_mode": 0,
                "persistent_mode": 1,
                "max_power": 75,
                **{
                    i: {
                        "powermizer_mode": 1,
                        "graphics_clock_offset": -150,
                        "memory_transfer_rate_offset": 1200,
                        "fan_control": 1,
                        "fan_speed": 60,
                    }
                    for i in graphic_cards
                },
            }

        return config

    def install(self, config: "Config"):
        """Performs the installation."""
        logger.info(
            "Default tuning configuration for nvidia graphic cards has been set in %s file.",
            os.path.join(config["shared"]["config"], "barrenero.toml"),
        )
        shutil.copy(os.path.join(PATH, "barrenero", "nvidia_tuning", "nvidia_tuning.py"), config["shared"]["lib"])

    def uninstall(self, config: "Config"):
        """Uninstall this module."""
        shutil.rmtree(os.path.join(config["shared"]["lib"], "nvidia_tuning.py"), ignore_errors=True)
