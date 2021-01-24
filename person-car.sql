create table car (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(19,2) NOT NULL
);

create table person (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	gender VARCHAR(20) NOT NULL,
	email VARCHAR(100) NOT NULL,
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR(50) NOT NULL,
    car_id BIGINT REFERENCES car (id),
    UNIQUE(car_id)
);

insert into person (first_name, last_name, gender, email, date_of_birth, country_of_birth) values ('Chrisy', 'Heistermann', 'Genderfluid', 'cheistermann0@last.fm', '1938/08/21', 'Cuba');
insert into person (first_name, last_name, gender, email, date_of_birth, country_of_birth) values ('Bradford', 'Dearnly', 'Genderqueer', 'bdearnly1@xinhuanet.com', '1969/07/19', 'Russia');
insert into person (first_name, last_name, gender, email, date_of_birth, country_of_birth) values ('Kalina', 'Fransson', 'Genderfluid', 'kfransson2@who.int', '1961/06/28', 'Sweden');

insert into car (make, model, price) values ('Mitsubishi', 'Starion', '98737.48');
insert into car (make, model, price) values ('Ford', 'LTD', '29127.55');
