import abc
import typing

if typing.TYPE_CHECKING:
    from config import Config


class Module:
    name: str = None

    @abc.abstractmethod
    def generate_config(
        self, shared_config: typing.Dict[str, typing.Any]
    ) -> typing.Union[None, str, int, float, bool, typing.Dict[str, typing.Any]]:
        """
        Ask for needed parameters and generate this module configuration.

        :param shared_config: Shared configuration across all modules.
        :return: Module configuration.
        """
        ...

    @abc.abstractmethod
    def install(self, config: "Config"):
        """Performs the installation."""
        ...

    @abc.abstractmethod
    def uninstall(self, config: "Config"):
        """Uninstall the module."""
        ...
