SELECT 	season_year, 
	home_team, 
-- 	home_score, 
	away_team, 
-- 	away_score,
	CASE 
		WHEN home_score > away_score THEN 1
		WHEN away_score > home_score THEN -1
		ELSE 0
	END AS winning
       
FROM 	game
WHERE 	season_year < 2013 
	AND season_type = 'Regular'
	AND CASE 
		WHEN home_score > away_score THEN 1
		WHEN away_score > home_score THEN -1
		ELSE 0
	END != 0;
