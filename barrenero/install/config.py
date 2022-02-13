import collections
import typing
from typing import MutableMapping, Iterator

import toml


class Config(MutableMapping):
    def __setitem__(self, k: str, v: typing.Any) -> None:
        self.config.__setitem__(k, v)

    def __delitem__(self, v: str) -> None:
        self.config.__delitem__(v)

    def __getitem__(self, k: str) -> typing.Any:
        return self.config.__getitem__(k)

    def __len__(self) -> int:
        return self.config.__len__()

    def __iter__(self) -> Iterator[str]:
        return self.config.__iter__()

    def __str__(self) -> str:
        return toml.dumps(collections.OrderedDict(sorted(self.config.items())))

    def __repr__(self) -> str:
        return f"Config({self!s})"

    def __init__(self):
        self.config: typing.Dict[str, typing.Any] = {}

    def load(self, path: str):
        with open(path) as f:
            self.config = toml.load(f)

    def dump(self, path: str):
        with open(path, "w") as f:
            toml.dump(collections.OrderedDict(sorted(self.config.items())), f)
