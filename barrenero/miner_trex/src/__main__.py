import sys

from clinner.run import Main
from clinner.command import Type as CommandType, command

from miner import Miner


@command(
    command_type=CommandType.PYTHON,
    args=((("-c", "--config-file"), {"help": "Config file"}),),
    parser_opts={"help": "Run TREX miner"},
)
def start(*args, **kwargs):
    Miner("/srv/apps/barrenero-miner-trex/t-rex", kwargs["config_file"]).run(*args)


if __name__ == "__main__":
    sys.exit(Main().run())
