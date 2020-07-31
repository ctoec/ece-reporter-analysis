import os
import io
import boto3
import pandas as pd
import sqlalchemy
import configparser
from resource_access.constants import CONFIG_FILE, HOST_KEY, USER_KEY, PASSWORD_KEY, DB_KEY, PORT_KEY,\
    S3_DATA_STORAGE, S3_ECE_DATA_PATH


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


def write_df_to_s3(df: pd.DataFrame, filename: str, section: str = S3_ECE_DATA_PATH,
                   bucket: str = S3_DATA_STORAGE, application: str = 'pensieve'):
    """
    Writes dataframe to specified S3 location based on the app's stage
    :param df: dataframe to upload to S3
    :param filename: name of file to be applied in S3
    :param section: section of S3 bucket where file will be written to
    :param bucket: S3 bucket to be written to
    :param application: Name of application for S3 storage
    :return: None
    """
    stage = os.environ['STAGE']
    s3_resource = boto3.resource('s3')
    key = application + '/' + stage + '/' + section + '/' + filename
    print(f"Uploading to {key}")
    s3_resource.Object(bucket, key).put(Body=df.to_csv(index=False))


def get_s3_subfolders(folder_prefix: str, bucket: str = S3_DATA_STORAGE) -> list:
    """
    Gets subfolders under the supplied prefix
    :param folder_prefix: Prefix above returned subfolders
    :param bucket: Bucket to pull from
    :return: list of full path strings of subfolders
    """
    s3_client = boto3.client('s3')
    obj_list = s3_client.list_objects_v2(Bucket=bucket, Prefix=folder_prefix)['Contents']
    complete_list = [os.path.dirname(x['Key']) for x in obj_list]
    # Deduplicate list
    return list(set(complete_list))


def get_s3_files_in_folder(folder_prefix: str, bucket: str = S3_DATA_STORAGE) -> dict:
    """
    Pull all files from S3 with the provided prefix
    :param folder_prefix: folder prefix to pull files from
    :param bucket: Bucket to pull files from
    :return: dictionary with keys of filename and values of dataframes
    """
    s3_client = boto3.client('s3')
    obj_list = s3_client.list_objects_v2(Bucket=bucket, Prefix=folder_prefix)['Contents']
    key_list = [o['Key'] for o in obj_list]
    return_dict = {}
    for key in key_list:
        file_object = s3_client.get_object(Bucket=S3_DATA_STORAGE, Key=key)
        return_dict[key.replace(folder_prefix + '/', '')] = pd.read_csv(io.BytesIO(file_object['Body'].read()),
                                                                        parse_dates=True)

    return return_dict

