import logging
import typing

from barrenero.install.modules.base import Module
from barrenero.install.modules.miner_trex import MinerTREXModule

logger = logging.getLogger("cli")

if typing.TYPE_CHECKING:
    from config import Config


class MinerModule(Module):
    name = "miner"

    MINER_MODULES = (MinerTREXModule(),)

    def generate_config(self, shared_config: typing.Dict[str, typing.Any]) -> typing.Dict[str, typing.Any]:
        """
        Ask for needed parameters and generate this module configuration.

        :param shared_config: Shared configuration across all modules.
        :return: Module configuration.
        """
        miners_config = {module.name: module.generate_config(shared_config) for module in self.MINER_MODULES}
        return {k: v for k, v in miners_config.items() if v is not None}

    def install(self, config: "Config"):
        """Performs the installation."""
        for module in (x for x in self.MINER_MODULES if x.name in config["miner"]):
            module.install(config)

    def uninstall(self, config: "Config"):
        """Uninstall this module."""
        for module in (x for x in self.MINER_MODULES if x.name in config["miner"]):
            module.uninstall(config)
