﻿-- DROP TABLE Data_PlayerPlay;
DROP TABLE Data_QBPlay;

SELECT 
		pr.player_id
		,pr.full_name
		,pr.position
		,pr.team
		,g.gsis_id
		,g.season_year
		,g.week
		,COUNT(DISTINCT pp.play_id) 	AS NbPlays
		,SUM(pp.passing_yds) 		AS passing_yds
		,SUM(pp.rushing_yds)		AS rushing_yds
		,SUM(pp.passing_int)		AS passing_int
INTO		Data_QBPlay
FROM 		player pr
LEFT JOIN 	play_player pp
	ON 	(pr.player_id = pp.player_id)
LEFT JOIN	game g
	ON	(g.gsis_id = pp.gsis_id)
WHERE		g.season_year = 2012
		AND g.season_type = 'Regular'
		AND pr.position = 'QB'
GROUP BY	pr.player_id
		,pr.full_name
		,pr.team
		,g.gsis_id
		,g.week
		,g.season_year
ORDER BY	pr.player_id
		,pr.full_name
 		,g.gsis_id
		,g.season_year
		,g.week
;

WITH AllGames AS (
SELECT	DISTINCT
	season_year
	,week
FROM 	game
WHERE	season_year = 2012
	AND season_type = 'Regular'
)
,DistinctPlayers AS (
SELECT 	DISTINCT
	player_id
	,full_name
	,position
	,team
FROM 	Data_QBPlay
)
,InitAllMatches AS (
SELECT
		pr.player_id
		,pr.full_name
		,pr.position
		,pr.team
		,NULL		AS gsis_id
		,g.season_year
		,g.week
		,0 		AS NbPlays
		,0 		AS passing_yds
		,0		AS rushing_yds
		,0		AS passing_int
FROM		DistinctPlayers pr
CROSS JOIN	AllGames g
-- ORDER BY pr.player_id, g.season_year, g.week
)
INSERT INTO 	Data_QBPlay
SELECT 
		i.*
FROM		InitAllMatches i
LEFT JOIN	Data_QBPlay d
	ON	(i.player_id = d.player_id AND
		i.season_year = d.season_year AND
		i.week = d.week)
WHERE		d.week IS NULL
;



