FROM python:3.7
COPY requirements.txt requirements.txt
# Follow https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update && apt-get install unixodbc-dev -y && ACCEPT_EULA=Y apt-get install msodbcsql17 mssql-tools -y
RUN pip install -r requirements.txt