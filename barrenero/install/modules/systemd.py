import logging
import os
import shlex
import subprocess
import typing

import jinja2
from clinner.inputs import bool_input

from barrenero.install.modules.base import Module
from barrenero.install.modules.nvidia_tuning import NvidiaTuningModule

if typing.TYPE_CHECKING:
    from config import Config

logger = logging.getLogger("cli")

PATH = os.path.realpath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))


class SystemdModule(Module):
    name = "systemd"

    def generate_config(self, shared_config: typing.Dict[str, typing.Any]) -> typing.Dict[str, typing.Any]:
        """
        Ask for needed parameters and generate this module configuration.

        :param shared_config: Shared configuration across all modules.
        :return: Module configuration.
        """
        return {"install": bool_input("Do you want to add Systemd services to run Barrenero?")}

    def install(self, config: "Config"):
        """Performs the installation."""
        j2_env = jinja2.Environment(
            loader=jinja2.FileSystemLoader(os.path.join(PATH, "barrenero", "install", "templates", "config", "systemd"))
        )

        excluded_templates = {
            k for k, v in {"barrenero_nvidia_tuning.service.j2": NvidiaTuningModule.name not in config}.items() if v
        }

        templates = (
            set(os.listdir(os.path.join(PATH, "barrenero", "install", "templates", "config", "systemd")))
            - excluded_templates
        )

        for template in templates:
            service_name = os.path.splitext(template)[0]

            with open(os.path.join("/etc/systemd/system/", service_name), "w") as f:
                f.write(j2_env.get_template(template).render(config))

            subprocess.run(shlex.split(f"systemctl enable {service_name}"))

    def uninstall(self, config: "Config"):
        """Uninstall this module."""
        for template in os.listdir(os.path.join(PATH, "barrenero", "install", "templates", "config", "systemd")):
            service_name = os.path.splitext(template)[0]

            subprocess.run(shlex.split(f"systemctl disable {service_name}"))

            try:
                os.remove(os.path.join("/etc/systemd/system/", service_name))
            except FileNotFoundError:
                ...
