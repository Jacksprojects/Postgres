# Getting started with POSTGRES

## Logging into POSTGRES in a terminal

First start by switching to user 'postgres'
`su postgres`

Then launch postgres using the `psql` command in the terminal.

To start off, change the password of this user by running the SQL command `ALTER USER postgres WITH PASSWORD 'passwordGoesHere';`

## Connecting to a database though the terminal

To connect to a database from the terminal, make sure that you're the user "postgres" then run the following:

`psql -h localhost -p 5432 -U postgres <DatabaseName>` Then you'll be promted for the password for the user 'postgres'.

`-h` Stands for "host"
`-p` Stands for "port" - the default value is 5432
`-U` Stands for "user" 
and the last argument is obviously the name of the database.
