# Getting started with PostgreSQL

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

`CREATE TABLE table_name (`</br>
 &nbsp;  &nbsp;  &nbsp;  &nbsp; `Column name + data type + constraints if there are any`</br>
`)`</br>

Here is an example of adding a table to the "test" database:

`\c test`</br>
`CREATE TABLE person (`</br>
`id INT,`</br>
`first_name VARCHAR(50),`</br>
`last_name VARCHAR(50),`</br>
`date_of_birth DATE );`</br>

This is a good start, but this is not an example of best practices. The following code specifies constraints that enforce data validity.

`\c test`</br>
`CREATE TABLE person (`</br>
`id BIGSERIAL NOT NULL PRIMARY KEY,`</br>
`first_name VARCHAR(50) NOT NULL,`</br>
`last_name VARCHAR(50) NOT NULL,`</br>
`date_of_birth DATE ) NOT NULL;`</br>

Ah whoops, looks like I entered the table without the `gender` variable, lets see if we can add it after we've already created the table:

`ALTER TABLE person`</br>
`ADD COLUMN gender VARCHAR(6) NOT NULL;`</br>


## Descriptions of tables

To see the column names and their data types you can use the following query:

`SELECT column_name, data_type FROM information_schema.columns`</br>
`WHERE table_name = '<Table_name>';`</br>

## Inserting records into tables

The basic syntax for adding records into tables follows this formula:

`INSERT INTO person (`</br>
`	first_name,`</br>
`	last_name,`</br>
`	gender,`</br>
`	date_of_birth)`</br>
`VALUES ('Anne', 'Smith', 'FEMALE', DATE '1988-02-22');`</br>

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
`SELECT * FROM person;`</br>

To select **specific columns**, just specify them followed by a comma:

`SELECT first_name, email FROM person;`</br>

To **order** the results (the default is ascending) specify the column that you want to order by:

`SELECT first_name, email FROM person`</br>
`ORDER BY email;`</br>

If you want to view **only unique values** ordered alphabetically, use the DISTINCT keyword then order by:

`SELECT DISTINCT country FROM person`</br>
`ORDER BY country;`

If you want to view only the records that fit **specific levels**, you can specify these with the WHERE keyword:

`SELECT * FROM person`</br>
`WHERE GENDER = 'MALE' AND country = 'Iceland';`

To return only a **specific number of levels** specify the number of records you want returned using the LIMIT keyword:

`SELECT * FROM person`</br>
`WHERE GENDER = 'Male' LIMIT 10;`

If you want to do this starting from row 5 for example, you can specify this using the OFFSET keyword:

`SELECT * FROM person`</br>
`WHERE GENDER = 'Male'`</br>
`OFFSET 5 LIMIT 10;`

# Queries with multiple conditions

* Multiple conditions can be specified after **AND** statements, just gotta wrap 'em with `()`

`SELECT * FROM person`</br>
`WHERE gender = 'FEMALE' AND (date_of_birth > '1980-01-01' OR date_of_birth < '1955-01-01')`</br>
`ORDER BY date_of_birth;`</br>

* To speed up writing **OR** statements if you have multiple conditons, you want to avoid repetition like this:

`SELECT * FROM person`</br>
`WHERE country_of_birth = 'China' OR country_of_birth = 'Brazil' OR country_of_birth = 'France'`</br>
`ORDER BY country_of_birth, date_of_birth;`</br>

* Instead, use the **IN** keyword, which takes an array of values:

`SELECT * FROM person`</br>
`WHERE country_of_birth IN ('China', 'Brazil', 'France')`</br>
`ORDER BY country_of_birth, date_of_birth;`</br>

# More Keywords

## Limit, Offset and Fetch

`SELECT * FROM person`</br>
`FETCH FIRST 10 ROWS ONLY;`</br>

## Between

* The **BETWEEN** keyword allows you to filter out rows by specifying a start and an end:

`SELECT * FROM person`</br>
`WHERE date_of_birth BETWEEN '1950-01-01' AND '1955-01-01'`</br>
`ORDER BY date_of_birth;`</br>

## LIKE and ILIKE

* `LIKE` and `ILIKE` can be used for pattern matching for returning values that match certain contions, pretty much like regular expressions:
* The `LIKE` keyword is also **case sensitive**, whereas **ILIKE** is not.

`SELECT * FROM person`</br>
`WHERE email LIKE '%mozilla%';`</br>

* The query above will return any results that contain the characters **mozilla**. The wildcard `%` means that there can be anything infront or behind the string.
* The `_` underscore character means that the query will have to match single characters, for example to get all of the three letter names from the database:

`SELECT first_name FROM person`</br>
`WHERE first_name LIKE '___'`</br>
`ORDER BY first_name;`</br>


## GROUP BY

* The `GROUP BY` condition is used in conjunction with an **Aggregate function** to return sets of values. The following query will return a list of countries and the number of people from the database who come from those countries. This works by calling the **COUNT(*)** function: 

`SELECT country_of_birth, COUNT(*) FROM person`</br>
`GROUP BY country_of_birth`</br>
`ORDER BY COUNT(*) DESC;`</br>


## HAVING

* This is used to add additional filters after making an aggregation. For example, with the query above, we aggregate by counting the number of results for each country in the table. Using the `HAVING` keyword, we can then filter the aggregated results using more conditions:

`SELECT country_of_birth, COUNT(*) FROM person` </br>
`GROUP BY country_of_birth` </br>
`HAVING COUNT(*) > 20` </br>
`ORDER BY COUNT(*) DESC;`</br>


## Calculating MAX, MIN and SUM

To use the `max` and `min` functions, they take the column names as arguments. The following query will return the max price. Simple.

`SELECT MAX(price) FROM car;` <br>

To get the average of all car prices, you can use the `AVG()` keyword in the exact same way. You'll want to use this with the `ROUND()` keyword otherwise you'll get a result with a stupid number of sigfigs.

`SELECT ROUND(AVG(price)) FROM car;` <br>

To find the average price of each make, we can execute the following with `GROUP BY`:

`SELECT make, ROUND(AVG(price)) FROM car`<br>
`GROUP BY make`<br>
`ORDER BY AVG(price);`

To find the sum of all of the cars, we can use the `SUM()` keyword:

`SELECT SUM(price) FROM car;`

To find the sum the prices of all of the cars, we do the same thing but use the `GROUP BY` keyword again:

`SELECT make, SUM(price) FROM car`<br>
`GROUP BY make`
`ORDER BY SUM(price);`

## Returning altered values

Say we wanted to know what half of the price would be for eveyr car in our table? We can return custom variables by creating them using `SELECT`. If we want to return everything but we also wanted to know half of the price of each car with 2 decimal places:

`SELECT *, ROUND(price * 0.5, 2) FROM car;`

This works, but it returns all of our results under the column name `round` which sucks, lets see if we can change that by using another keyword, `AS`:

`SELECT *, ROUND(price * 0.5, 2) AS half_price FROM car;`

# COALESCE and NULLIF

The `COALESCE` keyword takes unlimited arguments and will return the first argument that is not `NULL`.  

This is great for returning empty values as a string of your choice, say for example you want to return a list of all of the emails from the `person` table, yet some of them are missing, you can use `COALESCE` to convert them to a string such as `NA: Email not provided`. 

In the code below, `COALESCE` will return the email, as long as there is an email, and if there is not, it will return the second argument you give it, in this case this is the string `NA: Email not provided`.

`SELECT COALESCE(email, 'NA: Email not provided') FROM person;`

This behaves similarly to `NULLIF` which will return a `NULL` as log as the arguments that you provide it match. For example, `NULLIF(20, 20)` will return a `NULL`, however `NULLIF(20, 3)` will return `20`.

SELECT *, NULLIF(country_of_birth, 'China') AS null_if_china FROM person;

# Working with Dates
