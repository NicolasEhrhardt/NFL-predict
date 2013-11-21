DROP TABLE Data_WRAllPlay;

SELECT 
		-- Meta
		pr.player_id AS player_id_orig
		,pr.full_name
		,pr.position
		,pr.team
		,g.gsis_id
		-- Numbers
		,CAST(SUBSTRING(pr.player_id from 4) AS INTEGER) AS player_id
		,g.season_year			AS season_year
		,g.week				AS week
		,COALESCE(i.injury, 0)		AS injury_flag
		,COUNT(DISTINCT pp.play_id) 	AS nb_plays
		, SUM(pp.defense_ast)		AS defense_ast
		, SUM(pp.defense_ffum)      	AS defense_ffum
		, SUM(defense_fgblk)        	AS defense_fgblk
		, SUM(defense_frec)         	AS defense_frec
		, SUM(defense_frec_tds)         AS defense_frec_tds
		, SUM(defense_frec_yds)         AS defense_frec_yds
		, SUM(defense_int)          	AS defense_int
		, SUM(defense_int_tds)          AS defense_int_tds
		, SUM(defense_int_yds)          AS defense_int_yds
		, SUM(defense_misc_tds)         AS defense_misc_tds
		, SUM(defense_misc_yds)         AS defense_misc_yds
		, SUM(defense_pass_def)         AS defense_pass_def
		, SUM(defense_puntblk)          AS defense_puntblk
		, SUM(defense_qbhit)          	AS defense_qbhit
		, SUM(defense_safe)         	AS defense_safe
		, SUM(defense_sk)         	AS defense_sk
		, SUM(defense_sk_yds)         	AS defense_sk_yds
		, SUM(defense_tkl)          	AS defense_tkl
		, SUM(defense_tkl_loss)         AS defense_tkl_loss
		, SUM(defense_tkl_loss_yds)     AS defense_tkl_loss_yds
		, SUM(defense_tkl_primary)      AS defense_tkl_primary
		, SUM(defense_xpblk)          	AS defense_xpblk
		, SUM(fumbles_forced)         	AS fumbles_forced
		, SUM(fumbles_lost)         	AS fumbles_lost
		, SUM(fumbles_notforced)        AS fumbles_notforced
		, SUM(fumbles_oob)          	AS fumbles_oob
		, SUM(fumbles_rec)          	AS fumbles_rec
		, SUM(fumbles_rec_tds)          AS fumbles_rec_tds
		, SUM(fumbles_rec_yds)          AS fumbles_rec_yds
		, SUM(fumbles_tot)          	AS fumbles_tot
		, SUM(kicking_all_yds)          AS kicking_all_yds
		, SUM(kicking_downed)         	AS kicking_downed
		, SUM(kicking_fga)          	AS kicking_fga
		, SUM(kicking_fgb)          	AS kicking_fgb
		, SUM(kicking_fgm)          	AS kicking_fgm
		, SUM(kicking_fgm_yds)          AS kicking_fgm_yds
		, SUM(kicking_fgmissed)         AS kicking_fgmissed
		, SUM(kicking_fgmissed_yds)     AS kicking_fgmissed_yds
		, SUM(kicking_i20)          	AS kicking_i20
		, SUM(kicking_rec)          	AS kicking_rec
		, SUM(kicking_rec_tds)          AS kicking_rec_tds
		, SUM(kicking_tot)          	AS kicking_tot
		, SUM(kicking_touchback)        AS kicking_touchback
		, SUM(kicking_xpa)          	AS kicking_xpa
		, SUM(kicking_xpb)          	AS kicking_xpb
		, SUM(kicking_xpmade)         	AS kicking_xpmade
		, SUM(kicking_xpmissed)         AS kicking_xpmissed
		, SUM(kicking_yds)          	AS kicking_yds
		, SUM(kickret_fair)         	AS kickret_fair
		, SUM(kickret_oob)          	AS kickret_oob
		, SUM(kickret_ret)          	AS kickret_ret
		, SUM(kickret_tds)          	AS kickret_tds
		, SUM(kickret_touchback)        AS kickret_touchback
		, SUM(kickret_yds)          	AS kickret_yds
		, SUM(passing_att)          	AS passing_att
		, SUM(passing_cmp)          	AS passing_cmp
		, SUM(passing_cmp_air_yds)      AS passing_cmp_air_yds
		, SUM(passing_incmp)          	AS passing_incmp
		, SUM(passing_incmp_air_yds)    AS passing_incmp_air_yds
		, SUM(passing_int)          	AS passing_int
		, SUM(passing_sk)         	AS passing_sk
		, SUM(passing_sk_yds)         	AS passing_sk_yds
		, SUM(passing_tds)          	AS passing_tds
		, SUM(passing_twopta)         	AS passing_twopta
		, SUM(passing_twoptm)         	AS passing_twoptm
		, SUM(passing_twoptmissed)      AS passing_twoptmissed
		, SUM(passing_yds)          	AS passing_yds
		, SUM(punting_blk)          	AS punting_blk
		, SUM(punting_i20)          	AS punting_i20
		, SUM(punting_tot)          	AS punting_tot
		, SUM(punting_touchback)        AS punting_touchback
		, SUM(punting_yds)          	AS punting_yds
		, SUM(puntret_downed)         	AS puntret_downed
		, SUM(puntret_fair)         	AS puntret_fair
		, SUM(puntret_oob)          	AS puntret_oob
		, SUM(puntret_tds)          	AS puntret_tds
		, SUM(puntret_tot)          	AS puntret_tot
		, SUM(puntret_touchback)        AS puntret_touchback
		, SUM(puntret_yds)          	AS puntret_yds
		, SUM(receiving_rec)          	AS receiving_rec
		, SUM(receiving_tar)          	AS receiving_tar
		, SUM(receiving_tds)          	AS receiving_tds
		, SUM(receiving_twopta)       	AS receiving_twopta
		, SUM(receiving_twoptm)         AS receiving_twoptm
		, SUM(receiving_twoptmissed)    AS receiving_twoptmissed
		, SUM(receiving_yac_yds)        AS receiving_yac_yds
		, SUM(receiving_yds)          	AS receiving_yds
		, SUM(rushing_att)          	AS rushing_att
		, SUM(rushing_loss)         	AS rushing_loss
		, SUM(rushing_loss_yds)         AS rushing_loss_yds
		, SUM(rushing_tds)          	AS rushing_tds
		, SUM(rushing_twopta)         	AS rushing_twopta
		, SUM(rushing_twoptm)         	AS rushing_twoptm
		, SUM(rushing_twoptmissed)      AS rushing_twoptmissed
		, SUM(rushing_yds)          	AS rushing_yds
INTO		Data_WRAllPlay
FROM 		player pr
LEFT JOIN 	play_player pp
	ON 	(pr.player_id = pp.player_id)
LEFT JOIN	game g
	ON	(g.gsis_id = pp.gsis_id)
LEFT JOIN	data_injury i
	ON	(i.season_year = g.season_year AND
		i.week = g.week AND
		pr.full_name = i.full_name)
WHERE		g.season_type = 'Regular'
		AND pr.position = 'WR'
 		AND g.season_year < 2013
GROUP BY	pr.player_id
		,pr.full_name
		,pr.team
		,g.gsis_id
		,g.week
		,g.season_year
		,i.injury
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
WHERE	season_type = 'Regular' 
	AND season_year < 2013 
)
,DistinctPlayers AS (
SELECT 	DISTINCT
	player_id_orig
	,player_id
	,full_name
	,position
	,team
FROM 	Data_WRAllPlay
)
,InitAllMatches AS (
SELECT
		pr.player_id_orig
		,pr.full_name
		,pr.position
		,pr.team
		,NULL		AS gsis_id
		,pr.player_id
		,g.season_year
		,g.week
		, 0	AS injury_flag
		, 0	AS nb_plays	
		, 0     AS defense_ast
		, 0     AS defense_ffum
		, 0     AS defense_fgblk
		, 0     AS defense_frec
		, 0     AS defense_frec_tds
		, 0     AS defense_frec_yds
		, 0     AS defense_int
		, 0     AS defense_int_tds
		, 0     AS defense_int_yds
		, 0     AS defense_misc_tds
		, 0     AS defense_misc_yds
		, 0     AS defense_pass_def
		, 0     AS defense_puntblk
		, 0     AS defense_qbhit
		, 0     AS defense_safe
		, 0     AS defense_sk
		, 0     AS defense_sk_yds
		, 0     AS defense_tkl
		, 0     AS defense_tkl_loss
		, 0     AS defense_tkl_loss_yds
		, 0     AS defense_tkl_primary
		, 0     AS defense_xpblk
		, 0     AS fumbles_forced
		, 0     AS fumbles_lost
		, 0     AS fumbles_notforced
		, 0     AS fumbles_oob
		, 0     AS fumbles_rec
		, 0     AS fumbles_rec_tds
		, 0     AS fumbles_rec_yds
		, 0     AS fumbles_tot
		, 0     AS kicking_all_yds
		, 0     AS kicking_downed
		, 0     AS kicking_fga
		, 0     AS kicking_fgb
		, 0     AS kicking_fgm
		, 0     AS kicking_fgm_yds
		, 0     AS kicking_fgmissed
		, 0     AS kicking_fgmissed_yds
		, 0     AS kicking_i20
		, 0     AS kicking_rec
		, 0     AS kicking_rec_tds
		, 0     AS kicking_tot
		, 0     AS kicking_touchback
		, 0     AS kicking_xpa
		, 0     AS kicking_xpb
		, 0     AS kicking_xpmade
		, 0     AS kicking_xpmissed
		, 0     AS kicking_yds
		, 0     AS kickret_fair
		, 0     AS kickret_oob
		, 0     AS kickret_ret
		, 0     AS kickret_tds
		, 0     AS kickret_touchback
		, 0     AS kickret_yds
		, 0     AS passing_att
		, 0     AS passing_cmp
		, 0     AS passing_cmp_air_yds
		, 0     AS passing_incmp
		, 0     AS passing_incmp_air_yds
		, 0     AS passing_int
		, 0     AS passing_sk
		, 0     AS passing_sk_yds
		, 0     AS passing_tds
		, 0     AS passing_twopta
		, 0     AS passing_twoptm
		, 0     AS passing_twoptmissed
		, 0     AS passing_yds
		, 0     AS punting_blk
		, 0     AS punting_i20
		, 0     AS punting_tot
		, 0     AS punting_touchback
		, 0     AS punting_yds
		, 0     AS puntret_downed
		, 0     AS puntret_fair
		, 0     AS puntret_oob
		, 0     AS puntret_tds
		, 0     AS puntret_tot
		, 0     AS puntret_touchback
		, 0     AS puntret_yds
		, 0     AS receiving_rec
		, 0     AS receiving_tar
		, 0     AS receiving_tds
		, 0     AS receiving_twopta
		, 0     AS receiving_twoptm
		, 0     AS receiving_twoptmissed
		, 0     AS receiving_yac_yds
		, 0     AS receiving_yds
		, 0     AS rushing_att
		, 0     AS rushing_loss
		, 0     AS rushing_loss_yds
		, 0     AS rushing_tds
		, 0     AS rushing_twopta
		, 0     AS rushing_twoptm
		, 0     AS rushing_twoptmissed
		, 0     AS rushing_yds
		
FROM		DistinctPlayers pr
CROSS JOIN	AllGames g
-- ORDER BY pr.player_id, g.season_year, g.week
)
INSERT INTO 	Data_WRAllPlay
SELECT 
		i.*
FROM		InitAllMatches i
LEFT JOIN	Data_WRAllPlay d
	ON	(i.player_id_orig = d.player_id_orig AND
		i.season_year = d.season_year AND
		i.week = d.week)
WHERE		d.week IS NULL
;



