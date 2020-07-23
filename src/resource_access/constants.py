import os
dir_path = os.path.dirname(os.path.realpath(__file__))
CONFIG_FILE = dir_path + '/config.ini'
ECE_DB_SECTION = 'ECE Reporter DB'
ECIS_DB_SECTION = 'ECIS DB Snapshot'
PENSIEVE_DB_SECTION = 'Pensieve'

# Keys referring to configuration file
HOST_KEY = 'host'
DB_KEY = 'database'
USER_KEY = 'user'
PASSWORD_KEY = 'password'
PORT_KEY = 'port'

# S3
S3_DATA_STORAGE = 'pensieve-data-storage'
S3_ECE_DATA_PATH = 'ece'
ENROLLMENTS_FILE = 'enrollments.csv'
SPACES_FILE = 'spaces.csv'
REVENUE_FILE = 'revenue.csv'
