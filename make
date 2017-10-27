#!/usr/bin/env python3
import logging
import os
import shlex
import subprocess
import sys

import shutil
from functools import wraps

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

DONATE_TEXT = '''
This project is free and open sourced, you can use it, spread the word, contribute to the codebase and help us donating:
* Ether: 0x566d41b925ed1d9f643748d652f4e66593cba9c9
* Bitcoin: 1Jtj2m65DN2UsUzxXhr355x38T6pPGhqiA
* PayPal: barrenerobot@gmail.com
'''

SERVICES = {
    'api': {
        'url': 'https://github.com/PeRDy/barrenero-api',
        'name': 'barrenero-api',
        'systemd': ['barrenero_api']
    },
    'miner': {
        'url': 'https://github.com/PeRDy/barrenero-miner',
        'name': 'barrenero-miner',
        'systemd': ['barrenero_miner_ether', 'barrenero_miner_storj']
    },
    'telegram': {
        'url': 'https://github.com/PeRDy/barrenero-telegram',
        'name': 'barrenero-telegram',
        'systemd': ['barrenero_telegram']
    },
    'telegraf': {
        'url': 'https://github.com/PeRDy/barrenero-telegraf',
        'name': 'barrenero-telegraf',
        'systemd': ['barrenero_telegraf']
    },
}


class Main(ClinnerMain):
    commands = [
        'clinner.run.commands.sphinx.sphinx',
    ]


def superuser(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        if not os.geteuid() == 0:
            logger.error('Script must be run as root')
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


def default_input(input_str, default=None):
    input_str = input_str + ' [{}]: '.format(default)
    return input(input_str) or default


def bool_input(input_str):
    input_str = input_str + ' [Y|n] '
    result = None
    while result is None:
        response = input(input_str)
        if response in ('', 'y', 'Y'):
            result = True
        elif response in ('n', 'N'):
            result = False
        else:
            print('Wrong option')

    return result


def install_service(service, *args, **kwargs):
    service_path = os.path.abspath(os.path.join(os.getcwd(), SERVICES[service]['name']))

    # Clone or update
    if not os.path.exists(service_path):
        logger.info('Downloading Barrenero %s', service)
        service_repo = Repo.clone_from(SERVICES[service]['url'], service_path)
        service_repo.heads.master.set_tracking_branch(service_repo.remotes.origin.refs.master)
    else:
        logger.info('Updating Barrenero %s', service)
        service_repo = Repo(service_path)
        service_repo.remotes.origin.fetch()
        service_repo.heads.master.set_tracking_branch(service_repo.remotes.origin.refs.master)
        service_repo.remotes.origin.pull()

    # Run installation
    os.chdir(service_path)
    cmd_args = ' '.join(args)
    cmd_kwargs = ' '.join(['--{}={}'.format(k, v) if v is not None else '--{}'.format(k) for k, v in kwargs.items()])
    cmd = './make install {} {}'.format(cmd_kwargs, cmd_args)
    subprocess.run(shlex.split(cmd))


def update_service(service, path):
    service_path = os.path.abspath(os.path.join(path, 'barrenero', SERVICES[service]['name']))

    # Check if service already exists and update it
    if not os.path.exists(service_path):
        logger.info('Barrenero %s is not installed', service)
    else:
        logger.info('Updating Barrenero %s', service)
        service_repo = Repo(service_path)
        service_repo.remotes.origin.fetch()
        service_repo.heads.master.set_tracking_branch(service_repo.remotes.origin.refs.master)
        service_repo.remotes.origin.pull()


def restart_service(service, path):
    service_path = os.path.abspath(os.path.join(path, 'barrenero', SERVICES[service]['name']))

    # Check if service already exists and update it
    if not os.path.exists(service_path):
        logger.info('Barrenero %s is not installed', service)
    else:
        logger.info('Updating Barrenero %s', service)
        os.chdir(service_path)
        subprocess.run(shlex.split('./make restart'))


def build_service(service, path, no_cache):
    service_path = os.path.abspath(os.path.join(path, 'barrenero', SERVICES[service]['name']))

    # Check if service already exists and update it
    if not os.path.exists(service_path):
        logger.info('Barrenero %s is not installed', service)
    else:
        logger.info('Updating Barrenero %s', service)
        os.chdir(service_path)
        cmd = shlex.split('./make build')
        if no_cache:
            cmd.append('--no-cache')
        subprocess.run(cmd)


@command(command_type=CommandType.PYTHON,
         args=((('service',), {'help': 'Services to update', 'nargs': '+', 'choices': tuple(SERVICES.keys())}),
               (('--path',), {'help': 'Barrenero full path', 'default': '/usr/local/lib'}),),
         parser_opts={'help': 'Update Barrenero services'})
@donate
@superuser
def update(*args, **kwargs):
    for service in kwargs['service']:
        update_service(service, kwargs['path'])


@command(command_type=CommandType.PYTHON,
         args=((('service',), {'help': 'Services to install', 'nargs': '+', 'choices': tuple(SERVICES.keys())}),
               (('--path',), {'help': 'Barrenero full path', 'default': '/usr/local/lib'}),),
         parser_opts={'help': 'Install Barrenero services'})
@donate
@superuser
def install(*args, **kwargs):
    barrenero_path = os.path.abspath(os.path.join(kwargs['path'], 'barrenero'))
    if 'miner' in kwargs['service']:
        nvidia = bool_input('Do you want to install Nvidia Overclock service?')
        storj_path = default_input('Absolute path to Storj storage', default='/storage/storj')
        storj_ports = default_input('Ports range to be used by Storj', default='4000-4004')

        install_kwargs = {
            'path': barrenero_path
        }
        if nvidia:
            install_kwargs['nvidia'] = None

        install_service('miner', storj_path, storj_ports, **install_kwargs)

    if 'api' in kwargs['service']:
        install_service('api', path=barrenero_path)

    if 'telegram' in kwargs['service']:
        bot_token = input('Register your bot in Telegram (https://core.telegram.org/bots#creating-a-new-bot) and '
                          'introduce the token generated: ')
        install_service('telegram', bot_token, path=barrenero_path)

    if 'telegraf' in kwargs['service']:
        barrenero_api_token = input('Barrenero API token: ')
        influxdb_url = input('InfluxDB URL: ')
        influxdb_database = input('InfluxDB Database: ')
        influxdb_username = input('InfluxDB Username: ')
        influxdb_password = input('InfluxDB Password: ')

        install_kwargs = {
            'pathh': barrenero_path,
        }
        if influxdb_username:
            install_kwargs.update({
                'influxdb_username': influxdb_username,
                'influxdb_password': influxdb_password,
            })
        install_service('telegraf', barrenero_api_token, influxdb_url, influxdb_database, **install_kwargs)


@command(command_type=CommandType.PYTHON,
         args=((('service',), {'help': 'Services to install', 'nargs': '+', 'choices': tuple(SERVICES.keys())}),
               (('--path',), {'help': 'Barrenero full path', 'default': '/usr/local/lib'}),),
         parser_opts={'help': 'Restart Barrenero services'})
@donate
@superuser
def restart(*args, **kwargs):
    for service in kwargs['service']:
        restart_service(service, kwargs['path'])


@command(command_type=CommandType.PYTHON,
         args=((('service',), {'help': 'Services to build', 'nargs': '+', 'choices': tuple(SERVICES.keys())}),
               (('--no-cache',), {'help': 'Full build without using cache', 'action': 'store_true'}),
               (('--path',), {'help': 'Barrenero full path', 'default': '/usr/local/lib'}),),
         parser_opts={'help': 'Build Barrenero services'})
@donate
@superuser
def build(*args, **kwargs):
    for service in kwargs['service']:
        build_service(service, kwargs['path'], kwargs['no_cache'])


@command(command_type=CommandType.PYTHON, parser_opts={'help': 'Clean installer'})
@donate
def clean(*args, **kwargs):
    shutil.rmtree(os.path.abspath(os.path.join(os.getcwd(), 'barrenero-miner')), ignore_errors=True)
    shutil.rmtree(os.path.abspath(os.path.join(os.getcwd(), 'barrenero-api')), ignore_errors=True)
    shutil.rmtree(os.path.abspath(os.path.join(os.getcwd(), 'barrenero-telegram')), ignore_errors=True)
    shutil.rmtree(os.path.abspath(os.path.join(os.getcwd(), 'barrenero-telegraf')), ignore_errors=True)


if __name__ == '__main__':
    sys.exit(Main().run())
