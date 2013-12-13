# Function: computeFeatureTeam
# ============================
# compute feature of teams in teamList (usually called after swap players)

computeFeatureTeam <- function(features) {
  return(aggregate(. ~ next_team + season_year, data=features, FUN=sum));
}

# Function: computeFeatureTeamList
# ================================
# recompute feature of teams in teamList (usually called after swap players)

computeFeatureTeamList <- function(featurePlayer, teamList, seasonList) {
  featureTeams = list();

  for(team in teamList) {
    for(season in seasonList) {
      featTeam = computeFeatureTeam(
          featurePlayer[featurePlayer$next_team == team & featurePlayer$season_year == season, !(colnames(featurePlayer) %in% c("player_id", "position"))]
        );
      featureTeams <- rbind(featureTeams, featTeam);
    }
  }

  return(featureTeams);
}

# Function: getPlayersName
# ========================
# return player Names

getPlayersName <- function(playerInd) {
  return(as.character(unique(players$full_name[which(players$player_id %in% feature_players_cur$player_id[unlist(playerInd)])])))
}

# Function: computeGameFeature
# ============================
# compute feature of one game

computeGameFeature <- function(featTeamHome, featTeamAway) {
  return(featTeamHome - featTeamAway);
}
