#!/usr/bin/env python3
import logging
import os
import sys

try:
    from clinner.command import command, Type as CommandType
    from clinner.run import Main as ClinnerMain
    from git import Repo
except ImportError:
    import importlib
    import pip
    import site

    print('Installing dependencies')
    pip.main(['install', '--user', '-qq', 'clinner', 'GitPython'])

    importlib.reload(site)

    from clinner.command import command, Type as CommandType
    from clinner.run import Main as ClinnerMain
    from git import Repo

logger = logging.getLogger('cli')


class Main(ClinnerMain):
    commands = [
        'clinner.run.commands.sphinx.sphinx',
    ]


@command(command_type=CommandType.SHELL,
         args=((('--path',), {'help': 'Barrenero full path', 'default': '/usr/local/lib'}),),
         parser_opts={'help': 'Update all Barrenero services'})
def update(*args, **kwargs):
    api_path = os.path.abspath(os.path.join(kwargs['path'], 'barrenero-api'))
    if not os.path.exists(api_path):
        Repo.clone_from('', api_path)


if __name__ == '__main__':
    sys.exit(Main().run())
