SELECT 		player_id
		,MAX(
		CASE WHEN season_year = 2009 THEN team
		ELSE NULL END
		) AS team_2009
		,MAX(
		CASE WHEN season_year = 2010 THEN team
		ELSE NULL END
		) AS team_2010
		,MAX(
		CASE WHEN season_year = 2011 THEN team
		ELSE NULL END
		) AS team_2011
		,MAX(
		CASE WHEN season_year = 2012 THEN team
		ELSE NULL END
		) AS team_2012
FROM 		data_allplay
WHERE		team != 'UNK'
GROUP BY 	player_id;
