#!/usr/bin/env python3
import json
import logging
import os
import pprint
import shutil
import sys
import uuid
from functools import wraps

import jinja2

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

PATH = os.path.realpath(os.path.dirname(__file__))

DONATE_TEXT = '''
This project is free and open sourced, you can use it, spread the word, contribute to the codebase and help us donating:
* Ether: 0x566d41b925ed1d9f643748d652f4e66593cba9c9
* Bitcoin: 1Jtj2m65DN2UsUzxXhr355x38T6pPGhqiA
* PayPal: barrenerobot@gmail.com
'''

SERVICES = (
    'api',
    'miner',
    'telegram',
    'telegraf',
)


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
    if default is None:
        default = ''

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


def generate_miner_config(config):
    """
    Ask for config parameters of Barrenero Miner.

    :param config: Config dict.
    """
    config['miner'] = {}

    if bool_input('Do you want to install Ether Miner?'):
        config['miner']['ether'] = {
            'worker': default_input('Worker name', default='Barrenero')
        }

    if bool_input('Do you want to install Storj Miner?'):
        config['miner']['storj'] = {
            'storage': default_input('Storage path', default='/storage/storj/'),
            'ports': default_input('Node ports', default='4000-4003'),
        }

        logger.info('If you want to user Storj miner, put your node config in {}'.format(
            os.path.join(config['common']['path'], 'barrenero-miner', 'storj.json')))


def generate_api_config(config):
    """
    Ask for config parameters of Barrenero API.

    :param config: Config dict.
    """
    config['api'] = {
        'secret_key': default_input('A secret key', default=uuid.uuid4().hex),
        'ethplorer': default_input('Ethplorer API token: '),
    }


def generate_telegram_config(config):
    """
    Ask for config parameters of Barrenero Telegram.

    :param config: Config dict.
    """
    config['telegram'] = {
        'token': default_input('Register your bot in Telegram (https://core.telegram.org/bots#creating-a-new-bot)  '
                               'and introduce the token generated: ')
    }


def generate_telegraf_config(config):
    """
    Ask for config parameters of Barrenero Telegraf.

    :param config: Config dict.
    """
    config['telegraf'] = {
        'api_token': default_input('Create a user in Barrenero API and introduce its token: '),
        'influxdb_url': default_input('InfluxDB URL', default='https://influxdb.yourdomain.com'),
        'influxdb_database': default_input('InfluxDB Database', default='yourdatabase'),
    }

    if bool_input('InfluxDB needs authentication?'):
        config['telegraf'].update({
            'influxdb_username': default_input('InfluxDB Username'),
            'influxdb_password': default_input('InfluxDB Password'),
        })


def create_lib_files(config):
    os.makedirs(config['common']['lib'], exist_ok=True)
    j2_env = jinja2.Environment(loader=jinja2.FileSystemLoader(os.path.join(PATH, 'templates', 'lib')))

    for template in os.listdir(os.path.join(PATH, 'templates', 'lib')):
        with open(os.path.join(config['common']['lib'], os.path.splitext(template)[0]), 'w') as f:
            f.write(j2_env.get_template(template).render(config))


def create_config_files(config):
    """
    Create config files using templates based on given config.

    :param config: Jinja2 Context.
    """
    os.makedirs(config['common']['path'], exist_ok=True)
    j2_env = jinja2.Environment(loader=jinja2.FileSystemLoader(os.path.join(PATH, 'templates', 'config')))

    # Generate common config files
    for template in [i for i in os.listdir(os.path.join(PATH, 'templates', 'config'))
                     if os.path.isfile(os.path.join(PATH, 'templates', 'config', i))]:
        with open(os.path.join(config['common']['path'], os.path.splitext(template)[0]), 'w') as f:
            f.write(j2_env.get_template(template).render(config))

    # Generate config files for miner service
    os.makedirs(os.path.join(config['common']['path'], 'miner'), exist_ok=True)
    for template in os.listdir(os.path.join(PATH, 'templates', 'config', 'miner')):
        template_name = os.path.splitext(template)[0]
        miner_name = os.path.splitext(template_name)[0]
        if miner_name in config['miner']:
            with open(os.path.join(config['common']['path'], 'miner', template_name), 'w') as f:
                f.write(j2_env.get_template(os.path.join('miner', template)).render(config))

    # Generate config files for telegraf service
    if 'telegraf' in config:
        os.makedirs(os.path.join(config['common']['path'], 'telegraf'), exist_ok=True)
        for template in os.listdir(os.path.join(PATH, 'templates', 'config', 'telegraf')):
            with open(os.path.join(config['common']['path'], 'telegraf', os.path.splitext(template)[0]), 'w') as f:
                f.write(j2_env.get_template(os.path.join('telegraf', template)).render(config))

    # Generate config files for telegram service
    if 'telegram' in config:
        os.makedirs(os.path.join(config['common']['path'], 'telegram'), exist_ok=True)
        for template in os.listdir(os.path.join(PATH, 'templates', 'config', 'telegram')):
            with open(os.path.join(config['common']['path'], 'telegram', os.path.splitext(template)[0]), 'w') as f:
                f.write(j2_env.get_template(os.path.join('telegram', template)).render(config))

    # Generate config files for api service
    if 'api' in config:
        os.makedirs(os.path.join(config['common']['path'], 'api'), exist_ok=True)
        for template in os.listdir(os.path.join(PATH, 'templates', 'config', 'api')):
            with open(os.path.join(config['common']['path'], 'api', os.path.splitext(template)[0]), 'w') as f:
                f.write(j2_env.get_template(os.path.join('api', template)).render(config))


def create_log_dirs(config):
    """
    Create log directories based on given config.

    :param config: Config.
    """
    os.makedirs(config['common']['logs'], exist_ok=True)
    for service in [k for k in config if k in SERVICES]:
        os.makedirs(os.path.join(config['common']['logs'], service), exist_ok=True)


@command(command_type=CommandType.PYTHON,
         args=((('service',), {'help': 'Services to install', 'nargs': '+', 'choices': SERVICES}),
               (('-s', '--save-config'), {'help': 'Save generated config to given file'}),
               (('-c', '--config'), {'help': 'Config file'}),),
         parser_opts={'help': 'Install Barrenero services'})
@donate
@superuser
def install(*args, **kwargs):
    if kwargs['config']:
        with open(kwargs['config']) as f:
            config = json.load(f)
    else:
        config = {
            'common': {
                'path': default_input('Config files path', default='/etc/barrenero/'),
                'logs': default_input('Log files path', default='/var/log/barrenero/'),
                'lib': default_input('Lib files path', default='/usr/local/lib/barrenero/'),
                'email': default_input('Email', default='your@email.com'),
                'wallet': default_input('Wallet', default='0x566d41b925ed1d9f643748d652f4e66593cba9c9'),
            }
        }

        if bool_input('Do you want to install Nvidia Overclock service?'):
            config['common']['nvidia'] = default_input(
                'Which Nvidia graphics card want to overclock?', default='0,1,2,3,4').split(',')

        generate_miner_config(config)

        if 'api' in kwargs['service']:
            generate_api_config(config)

        if 'telegram' in kwargs['service']:
            generate_telegram_config(config)

        if 'telegraf' in kwargs['service']:
            generate_telegraf_config(config)

    print('This is your current config:\n{}'.format(pprint.pformat(config, indent=2, width=120)))
    if kwargs['save_config']:
        with open(kwargs['save_config'], 'w') as f:
            json.dump(config, f)

    if bool_input('Do you want to proceed with installation?'):
        create_config_files(config)
        create_log_dirs(config)
        create_lib_files(config)


@command(command_type=CommandType.PYTHON,
         args=((('--path',), {'help': 'Barrenero config full path', 'default': '/etc/barrenero/'}),
               (('--log-path',), {'help': 'Barrenero log full path', 'default': '/var/log/barrenero/'}),
               (('--lib-path',), {'help': 'Barrenero lib full path', 'default': '/usr/local/lib/barrenero/'}),
               (('-c', '--config'), {'help': 'Config file'}),),
         parser_opts={'help': 'Clean installer'})
@donate
@superuser
def clean(*args, **kwargs):
    if kwargs['config']:
        with open(kwargs['config']) as f:
            config = json.load(f)

        config_path = config['common']['path']
        log_path = config['common']['logs']
        lib_path = config['common']['lib']
    else:
        config_path = kwargs['path']
        log_path = kwargs['logs']
        lib_path = kwargs['lib']

    shutil.rmtree(os.path.abspath(config_path), ignore_errors=True)
    shutil.rmtree(os.path.abspath(log_path), ignore_errors=True)
    shutil.rmtree(os.path.abspath(lib_path), ignore_errors=True)


class Main(ClinnerMain):
    commands = [
        'clinner.run.commands.sphinx.sphinx',
        'install',
        'clean',
    ]


if __name__ == '__main__':
    sys.exit(Main().run())
