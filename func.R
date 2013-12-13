# Function: computeFeatureTeam
# ============================
# compute feature of teams in teamList (usually called after swap players)

computeFeatureTeam <- function(features) {
  # simple Sum
  # return(aggregate(. ~ next_team + season_year, data=features, FUN=sum));
  # double aggregation
  sumData <- aggregate(. ~ next_team + season_year, data=features, FUN = max);
  maxData <- aggregate(. ~ next_team + season_year, data=features, FUN = sum);
  meanData <- aggregate(. ~ next_team + season_year, data=features, FUN = mean);
  return(merge(sumData, maxData, by=c("next_team", "season_year")));
  # triple aggregation
  # return(merge(merge(sumData, maxData, by=c("next_team", "season_year")), meanData, by=c("next_team", "season_year")));
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


# Function: computeGameFeature
# ============================
# compute feature of one game

computeGameFeature <- function(featTeamHome, featTeamAway) {
  return(featTeamHome - featTeamAway);
}
