import os
import sqlalchemy
import configparser

dir_path = os.path.dirname(os.path.realpath(__file__))
CONFIG_FILE = dir_path + '/config.ini'
ECE_DB_SECTION = 'ECE Reporter DB'

# Keys referring to configuration file
HOST_KEY = 'host'
DB_KEY = 'database'
USER_KEY = 'user'
PASSWORD_KEY = 'password'
PORT_KEY = 'port'

def get_connection(config_file: str = CONFIG_FILE) -> sqlalchemy.engine:
    """
    Reads a configuration file, connects to the specified database and returns sqlalchemy engine
    :param config_file: path to configuration file
    :return engine: SQLAlchemy connection object
    """
    config = configparser.ConfigParser()
    config.read(config_file)

    # Get credentials from config file
    ece_db_dict = config[ECE_DB_SECTION]
    host = ece_db_dict[HOST_KEY]
    user_name = ece_db_dict[USER_KEY]
    password = ece_db_dict[PASSWORD_KEY]
    db_name = ece_db_dict[DB_KEY]
    port = ece_db_dict[PORT_KEY]

    # Create and return DB connection
    conn_string = f"mssql+pyodbc://{user_name}:{password}@{host},{port}/{db_name}?driver=ODBC+Driver+17+for+SQL+Server&Mars_Connection=Yes"
    engine = sqlalchemy.create_engine(conn_string)
    conn = engine.connect()
    return conn

