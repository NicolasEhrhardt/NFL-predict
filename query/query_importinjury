CREATE TABLE injury (
	season_year numeric, 
	full_name character varying(100),
	week1 varchar(10),
	week2 varchar(10),
	week3 varchar(10),
	week4 varchar(10),
	week5 varchar(10),
	week6 varchar(10),
	week7 varchar(10),
	week8 varchar(10),
	week9 varchar(10),
	week10 varchar(10),
	week11 varchar(10),
	week12 varchar(10),
	week13 varchar(10),
	week14 varchar(10),
	week15 varchar(10),
	week16 varchar(10)
	);

TRUNCATE TABLE injury;
COMMIT;

COPY injury(
	season_year,
	full_name, 
	week1, 
	week2, 
	week3, 
	week4, 
	week5, 
	week6, 
	week7, 
	week8, 
	week9, 
	week10, 
	week11, 
	week12, 
	week13, 
	week14, 
	week15, 
	week16
	)
FROM '/home/nicolas/Code/nodejs/scrapenfl/data/allClean2010.csv'
WITH DELIMITER ','
CSV QUOTE '"';

COPY injury(
	season_year,
	full_name, 
	week1, 
	week2, 
	week3, 
	week4, 
	week5, 
	week6, 
	week7, 
	week8, 
	week9, 
	week10, 
	week11, 
	week12, 
	week13, 
	week14, 
	week15, 
	week16
	)
FROM '/home/nicolas/Code/nodejs/scrapenfl/data/allClean2011.csv'
WITH DELIMITER ','
CSV QUOTE '"';

COPY injury(
	season_year,
	full_name, 
	week1, 
	week2, 
	week3, 
	week4, 
	week5, 
	week6, 
	week7, 
	week8, 
	week9, 
	week10, 
	week11, 
	week12, 
	week13, 
	week14, 
	week15, 
	week16
	)
FROM '/home/nicolas/Code/nodejs/scrapenfl/data/allClean2012.csv'
WITH DELIMITER ','
CSV QUOTE '"';