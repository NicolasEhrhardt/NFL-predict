SELECT
season_year
,week
,full_name
,CASE injury
WHEN 'P' THEN 1 
WHEN 'Q' THEN 2 
WHEN 'D' THEN 3 
WHEN 'O' THEN 4 
WHEN 'PUP' THEN 5 
WHEN 'IR' THEN 6 
ELSE 0
END AS injury
INTO data_injury
FROM injury;