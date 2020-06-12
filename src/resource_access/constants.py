import os
dir_path = os.path.dirname(os.path.realpath(__file__))
CONFIG_FILE = dir_path + '/config.ini'
ECE_DB_SECTION = 'ECE Reporter DB'
ECIS_DB_SECTION = 'ECIS DB Snapshot'

# Keys referring to configuration file
HOST_KEY = 'host'
DB_KEY = 'database'
USER_KEY = 'user'
PASSWORD_KEY = 'password'
PORT_KEY = 'port'