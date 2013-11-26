SELECT 		player_id_orig
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
GROUP BY 	player_id_orig, 
		team
HAVING 		MAX(
		CASE WHEN season_year = 2011 THEN team
		ELSE NULL END
		)
		!= MAX(
		CASE WHEN season_year = 2012 THEN team
		ELSE NULL END
		)

  
  
        


       week, injury_flag, nb_plays, defense_ast, defense_ffum, 
       defense_fgblk, defense_frec, defense_frec_tds, defense_frec_yds, 
       defense_int, defense_int_tds, defense_int_yds, defense_misc_tds, 
       defense_misc_yds, defense_pass_def, defense_puntblk, defense_qbhit, 
       defense_safe, defense_sk, defense_sk_yds, defense_tkl, defense_tkl_loss, 
       defense_tkl_loss_yds, defense_tkl_primary, defense_xpblk, fumbles_forced, 
       fumbles_lost, fumbles_notforced, fumbles_oob, fumbles_rec, fumbles_rec_tds, 
       fumbles_rec_yds, fumbles_tot, kicking_all_yds, kicking_downed, 
       kicking_fga, kicking_fgb, kicking_fgm, kicking_fgm_yds, kicking_fgmissed, 
       kicking_fgmissed_yds, kicking_i20, kicking_rec, kicking_rec_tds, 
       kicking_tot, kicking_touchback, kicking_xpa, kicking_xpb, kicking_xpmade, 
       kicking_xpmissed, kicking_yds, kickret_fair, kickret_oob, kickret_ret, 
       kickret_tds, kickret_touchback, kickret_yds, passing_att, passing_cmp, 
       passing_cmp_air_yds, passing_incmp, passing_incmp_air_yds, passing_int, 
       passing_sk, passing_sk_yds, passing_tds, passing_twopta, passing_twoptm, 
       passing_twoptmissed, passing_yds, punting_blk, punting_i20, punting_tot, 
       punting_touchback, punting_yds, puntret_downed, puntret_fair, 
       puntret_oob, puntret_tds, puntret_tot, puntret_touchback, puntret_yds, 
       receiving_rec, receiving_tar, receiving_tds, receiving_twopta, 
       receiving_twoptm, receiving_twoptmissed, receiving_yac_yds, receiving_yds, 
       rushing_att, rushing_loss, rushing_loss_yds, rushing_tds, rushing_twopta, 
       rushing_twoptm, rushing_twoptmissed, rushing_yds
  FROM data_allplay order by player_id limit 5
