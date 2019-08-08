----Drop Firearms table
DROP TABLE IF EXISTS firearms;

CREATE TABLE firearms (
id int, 
age_group TEXT,
sex TEXT,
mode TEXT,
count TEXT,
injury_type TEXT, 
PRIMARY KEY (age_group, sex, mode)
); 

SELECT * FROM firearms;

----Drop Firearms table to create 3 column key
DROP TABLE IF EXISTS firearms;

CREATE TABLE firearms (
age_group TEXT,
sex TEXT,
mode TEXT,
count INT,
injury_type TEXT, 
PRIMARY KEY (age_group, sex, mode)
);

SELECT * FROM firearms;

----Drop Injury table to create a three column key
DROP TABLE IF EXISTS injury;

CREATE TABLE injury (
age_group TEXT,
sex TEXT,
diagnosis TEXT,
count INT, 
PRIMARY KEY (age_group, sex, diagnosis)
);

SELECT * FROM injury;

----Drop Population  table to create a three column key
DROP TABLE IF EXISTS population;

CREATE TABLE population (
age_group TEXT,
sex TEXT,
population INT,
PRIMARY KEY (age_group, sex)
);

SELECT * FROM population;

----Drop Injury table to create a three column key
DROP TABLE IF EXISTS injury;

CREATE TABLE injury (
age_group TEXT,
sex TEXT,
diagnosis INT,
count INT, 
PRIMARY KEY (age_group, sex, diagnosis)
);

DELETE FROM firearms;

SELECT * FROM injury;

DROP TABLE IF EXISTS diagnosis;

CREATE TABLE diagnosis (
diagnosis TEXT, 
code INT PRIMARY KEY
);

SELECT * FROM diagnosis;

