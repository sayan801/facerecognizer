function conn =   OpenMySqlConnection(databaseName)

%# JDBC connector path
javaaddpath('C:\Users\chandra\Documents\MATLAB\mysql-connector-java-5.0.8\mysql-connector-java-5.0.8-bin.jar')
%# connection parameteres
host = 'localhost';     %MySQL hostname
user = 'root';          %MySQL username
password = 'technicise';%MySQL password
dbName = databaseName; %MySQL database name
%# JDBC parameters
jdbcString = sprintf('jdbc:mysql://%s/%s', host, dbName);
jdbcDriver = 'com.mysql.jdbc.Driver';

%# Create the database connection object
conn = database(dbName, user , password, jdbcDriver, jdbcString);
