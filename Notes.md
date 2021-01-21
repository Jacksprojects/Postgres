# Getting started with POSTGRES

## Logging into POSTGRES in a terminal

First start by switching to user 'postgres'
`su postgres`

Then launch postgres using the `psql` command in the terminal.

To start off, change the password of this user by running the SQL command `ALTER USER postgres WITH PASSWORD 'passwordGoesHere';`

## Viewing databases

Use `\l` to list all available databases.

## Connecting to a database though the terminal

To connect to a database from the terminal, make sure that you're the user "postgres" then run the following:

`psql -h localhost -p 5432 -U postgres <DatabaseName>` Then you'll be promted for the password for the user 'postgres'.

`-h` Stands for "host"
`-p` Stands for "port" - the default value is 5432
`-U` Stands for "user" 
and the last argument is obviously the name of the database.

Alternatively, you can connect to psql from the terminal then use the `\c <DatabaseName>` command to connect directly to the database.

## Viewing tables within a database

Use `\dt` to see all tables within a database.

# Basics

## Creating databases

`CREATE DATABASE <DatabaseName>`

## Removing databases

`DROP DATABASE <DatabaseName>`

## Adding tables to a database

The basic syntax for adding new tables to a database follows this formula:

CREATE TABLE table_name (
	Column name + data type + constraints if there are any
)

Here is an example of adding a table to the "test" database:

`\c test`
`CREATE TABLE person (`
`id INT,`
`first_name VARCHAR(50),`
`last_name VARCHAR(50),`
`date_of_birth DATE );`

This is a good start, but this is not an example of best practices. The following code specifies constraints that enforce data validity.

`\c test`
`CREATE TABLE person (`
`id BIGSERIAL NOT NULL PRIMARY KEY,`
`first_name VARCHAR(50) NOT NULL,`
`last_name VARCHAR(50) NOT NULL,`
`date_of_birth DATE ) NOT NULL;`  

Ah whoops, looks like I entered the table without the `gender` variable, lets see if we can add it after we've already created the table:

`ALTER TABLE person`
`ADD COLUMN gender VARCHAR(6) NOT NULL;`


## Descriptions of tables

To see the column names and their data types you can use the following query:

`SELECT column_name, data_type FROM information_schema.columns`
`WHERE table_name = '<Table_name>';`

## Inserting records into tables

The basic syntax for adding records into tables follows this formula:

`INSERT INTO person (`
`	first_name,`
`	last_name,`
`	gender,`
`	date_of_birth)`
`VALUES ('Anne', 'Smith', 'FEMALE', DATE '1988-02-22');`

Lets add 1000 new people using the site 'Mockaroo'. First specify the names of the columns you want and how many entries you want generated, then save the file as .sql

To run instructions from a file in the psql console, use the `\i` command followed by the location of the file which is this case was `\i /home/jack/Downloads/person.sql`. 

# Basic Queries

## Basic verbs

* **SELECT**
* **WHERE**
* **ORDER BY**
* **DISTINCT**
* **LIMIT**

## Getting started

To return **all columns** from a table use the command:
`SELECT * FROM person;`

To select **specific columns**, just specify them followed by a comma:

`SELECT first_name, email FROM person;`

To **order** the results (the default is ascending) specify the column that you want to order by:

`SELECT first_name, email FROM person`
`ORDER BY email;`

If you want to view **only unique values** ordered alphabetically, use the DISTINCT keyword then order by:

`SELECT DISTINCT country FROM person`
`ORDER BY country;`

If you want to view only the records that fit **specific levels**, you can specify these with the WHERE keyword:

`SELECT * FROM person`
`WHERE GENDER = 'MALE' AND country = 'Iceland';`

To return only a **specific number of levels** specify the number of records you want returned using the LIMIT keyword:

`SELECT * FROM person`
`WHERE GENDER = 'Male' LIMIT 10;`

If you want to do this starting from row 5 for example, you can specify this using the OFFSET keyword:

`SELECT * FROM person`
`WHERE GENDER = 'Male'` 
`OFFSET 5 LIMIT 10;`

## Queries with multiple conditions

* Multiple conditions can be specified after **AND** statements, just gotta wrap 'em with `()`

`SELECT * FROM person`
`WHERE gender = 'FEMALE' AND *(date_of_birth > '1980-01-01' OR date_of_birth < '1955-01-01')*`
`ORDER BY date_of_birth;`

* To speed up writing **OR** statements if you have multiple conditons, you want to avoid repetition like this:

`SELECT * FROM person`
`WHERE country_of_birth = 'China' OR country_of_birth = 'Brazil' OR country_of_birth = 'France'`
`ORDER BY country_of_birth, date_of_birth;`

* Instead, use the **IN** keyword, which takes an array of values:

`SELECT * FROM person`
`WHERE country_of_birth IN ('China', 'Brazil', 'France')`
`ORDER BY country_of_birth, date_of_birth;`

## Limit, Offset and Fetch

`SELECT * FROM person`
`FETCH FIRST 10 ROWS ONLY;`

## Between

* The **BETWEEN** keyword allows you to filter out rows by specifying a start and an end:

`SELECT * FROM person`
`WHERE date_of_birth BETWEEN '1950-01-01' AND '1955-01-01'`
`ORDER BY date_of_birth;`

## LIKE and ILIKE

* `LIKE` and `ILIKE` can be used for pattern matching for returning values that match certain contions, pretty much like regular expressions:
* The `LIKE` keyword is also **case sensitive**, whereas **ILIKE** is not.

`SELECT * FROM person`
`WHERE email LIKE '%mozilla%';`

* The query above will return any results that contain the characters **mozilla**. The wildcard `%` means that there can be anything infront or behind the string.
* The `_` underscore character means that the query will have to match single characters, for example to get all of the three letter names from the database:

`SELECT first_name FROM person`
`WHERE first_name LIKE '___'`
`ORDER BY first_name;`


## GROUP BY

* The `GROUP BY` condition is used in conjunction with an **Aggregate function** to return sets of values. The following query will return a list of countries and the number of people from the database who come from those countries. This works by calling the **COUNT(*)** function: 

`SELECT country_of_birth, COUNT(*) FROM person`
`GROUP BY country_of_birth`
`ORDER BY COUNT(*) DESC;`


## HAVING

* This is used to add additional filters after making an aggregation. For example, with the query above, we aggregate by counting the number of results for each country in the table. Using the `HAVING` keyword, we can then filter the aggregated results using more conditions:

`SELECT country_of_birth, COUNT(*) FROM person`
`GROUP BY country_of_birth`
`HAVING COUNT(*) > 20`
`ORDER BY COUNT(*) DESC;`

# MAX, MIN and SUM


















