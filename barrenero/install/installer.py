import os
import shutil

import jinja2
from clinner.inputs import default_input

from barrenero.install.config import Config
from barrenero.install.modules.miner import MinerModule
from barrenero.install.modules.nvidia_tuning import NvidiaTuningModule
from barrenero.install.modules.systemd import SystemdModule

PATH = os.path.realpath(os.path.join(os.path.dirname(__file__), "..", ".."))


class Installer:
    MODULES = (MinerModule(), NvidiaTuningModule(), SystemdModule())
    SERVICES = ("miner", "nvidia_tuning")

    def __init__(self):
        self.config = Config()

    def generate_config(self):
        self.config["shared"] = {
            "config": default_input("Config files path", default="/etc/barrenero/"),
            "logs": default_input("Log files path", default="/var/log/barrenero/"),
            "lib": default_input("Lib files path", default="/usr/local/lib/barrenero/"),
        }

        modules_config = {module.name: module.generate_config(self.config["shared"]) for module in self.MODULES}
        self.config.update({k: v for k, v in modules_config.items() if v is not None})

    def _create_log_dirs(self):
        os.makedirs(self.config["shared"]["logs"], exist_ok=True)

        # Create a directory for each service
        for service in [k for k in self.config if k in self.SERVICES]:
            os.makedirs(os.path.join(self.config["shared"]["logs"], service), exist_ok=True)

    def _create_config_dirs(self):
        os.makedirs(self.config["shared"]["config"], exist_ok=True)

    def _create_lib_dirs(self):
        os.makedirs(self.config["shared"]["lib"], exist_ok=True)

    def install(self):
        # Create dirs structure
        self._create_log_dirs()
        self._create_config_dirs()
        self._create_lib_dirs()

        # Store config
        self.config.dump(os.path.join(self.config["shared"]["config"], "barrenero.toml"))

        j2_env = jinja2.Environment(
            loader=jinja2.FileSystemLoader(os.path.join(PATH, "barrenero", "install", "templates", "config"))
        )

        with open(os.path.join(os.path.join(self.config["shared"]["lib"]), "docker-compose.yml"), "w") as f:
            f.write(j2_env.get_template("docker-compose.yml.j2").render(self.config))

        # Install all modules
        for module in (x for x in self.MODULES if x.name in self.config):
            module.install(self.config)

    def uninstall(self):
        # Uninstall all modules
        for module in (x for x in self.MODULES if x.name in self.config):
            module.uninstall(self.config)

        shutil.rmtree(os.path.abspath(self.config["shared"]["config"]), ignore_errors=True)
        shutil.rmtree(os.path.abspath(self.config["shared"]["logs"]), ignore_errors=True)
        shutil.rmtree(os.path.abspath(self.config["shared"]["lib"]), ignore_errors=True)
