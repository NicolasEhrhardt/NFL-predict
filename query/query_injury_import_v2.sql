CREATE TABLE injury (
	season_year numeric,
	week numeric,
	full_name character varying(100),
	injury varchar(10)
	);

TRUNCATE TABLE injury;
COMMIT;

COPY injury(
	season_year,
	week,
	full_name, 
	injury
	)
FROM '/home/nicolas/Code/nodejs/scrapenfl/data/allClean2010.csv'
WITH DELIMITER ','
CSV QUOTE '"';

COPY injury(
	season_year,
	week,
	full_name, 
	injury
	)
FROM '/home/nicolas/Code/nodejs/scrapenfl/data/allClean2011.csv'
WITH DELIMITER ','
CSV QUOTE '"';

COPY injury(
	season_year,
	week,
	full_name, 
	injury
	)
FROM '/home/nicolas/Code/nodejs/scrapenfl/data/allClean2012.csv'
WITH DELIMITER ','
CSV QUOTE '"';