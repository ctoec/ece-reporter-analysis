import sqlalchemy
import configparser
from resource_access.constants import CONFIG_FILE, HOST_KEY, USER_KEY, PASSWORD_KEY, DB_KEY, PORT_KEY


def get_mysql_connection(section: str, config_file: str = CONFIG_FILE) -> sqlalchemy.engine.base.Connection:
    """
    Reads a configuration file, connects to the specified database and returns sqlalchemy engine
    :param section: section of configuration file that has DB creds
    :param config_file: path to configuration file
    :return engine: SQLAlchemy connection object
    """
    config = configparser.ConfigParser()
    config.read(config_file)

    # Get credentials from config file
    ece_db_dict = config[section]
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