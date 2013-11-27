source('pred.R')

########################
## Evaluation Library ##
########################

# Function: swapPlayers
# =====================
# Swap players in the dataframe (no computation)

swapPlayers <- function(featurePlayer, playerFrom, playerTo) {
  temp = featurePlayer$next_team[playerFrom];
  
  featurePlayer$next_team[playerFrom] <- featurePlayer$next_team[playerTo];
  featurePlayer$next_team[playerTo] <- temp;

  return(featurePlayer);
}



# Function: evaluateTeam
# ======================
# Compute the prediction of the number of victories

evaluateTeam <- function(featureTeam, model, evalTeam) {
  x1 = list();
  x2 = list();
  for(otherTeam in unique(featureTeam$next_team[featureTeam$next_team != evalTeam])) {
    x1 <- rbind(
      x1, 
      computeGameFeature(
        featureTeam[featureTeam$next_team == evalTeam, -c(1, 2)], 
        featureTeam[featureTeam$next_team == otherTeam, -c(1, 2)]
      )
    );
    x2 <- rbind(
      x2, 
      computeGameFeature(
        featureTeam[featureTeam$next_team == otherTeam, -c(1, 2)], 
        featureTeam[featureTeam$next_team == evalTeam, -c(1, 2)]
      )
    );
  }
  pred1 = predict(model, x1);
  pred2 = predict(model, x2);

  predict1 = pred1$predictions;
  predict2 = pred2$predictions;

  return( (sum((predict1+1)/2) + sum((1-predict2)/2)) / (length(predict1) + length(predict2)) );
}

########################
## Evaluation scripts ##
########################

# This section contains example of how to use the previous work:

# For this example, we will load only 2012 data (hence predict 2013 season)

# feature_players_cur contains one row per player with its stats. The variable next_team contains the team the player will play in the next year (here in 2013)
feature_players_cur <- players_clusters[players_clusters$season_year==2012,]

# feature_teams_cur contains one row per team. To ask for a special team, use next_team
feature_team_cur <- feature_team[feature_team$season_year==2012,];

# ex: show to me the features of team ARI
# print(feature_team_cur[feature_team_cur$next_team=="ARI",])

# Example of use of function evaluateTeam
# This function is unfortunately particularly slow :(
# nb: model is a constant variable created by the ML part
# use levels(feature_team_cur$next_team) after "in" if you want to evaluate all the teams

for(team in c("ARI", "ATL")) {
  message("Evaluate team ", team, ": ", round(evaluateTeam(feature_team_cur, model, team) * 100, 2), "%");
}


# If you want to get a list of the players Id, use which (give index in a dataframe)
# ex: I want to know the indexes of the players of ARI:
 
all <- which(feature_players_cur$next_team == "ARI" & feature_players_cur$position == "WR")


# Here, as an example, I will swap two players and recompute the evaluation for the two teams
message("swapping players")
#feature_players_cur <- swapPlayers(feature_players_cur, 1026, 535);
feature_players_cur <- swapPlayers(feature_players_cur, 140, 535);

# drop the previous feature vector for the two teams
feature_team_cur <- feature_team_cur[!feature_team_cur$next_team %in% c("ARI", "ATL"), ];

# add recomputed feature for the two teams
feature_team_cur <- rbind(feature_team_cur, computeFeatureTeamList(feature_players_cur, c("ARI", "ATL"), c(2012)));

for(team in c("ARI", "ATL")) {
  message("Evaluate team ", team, ": ", round(evaluateTeam(feature_team_cur, model, team) * 100, 2), "%");
}



allTeams1 <- createTeams(list("ARI","ATL","BAL"),"WR")
message("allTeams1")
print(allTeams1)
swap(535,"ARI",140,"ATL")
#swap2(feature_players_cur,140,535)
#getValueAndSwap(535,"ARI",140,"ATL")
#feature_players_cur <- swapPlayers(feature_players_cur,140,535)



allTeams2 <- createTeams(list("ARI","ATL","BAL"),"WR")
message("allTeams2")
print(allTeams2)
















################## Wrapper Functions ####################

getValueAndSwap <- function(player1,team1,player2,team2){

    feature_players_cur <- players_clusters[players_clusters$season_year==2012,]
    feature_team_cur <- feature_team[feature_team$season_year==2012,];
    
    feature_players_cur <- swapPlayers(feature_players_cur, player1, player2);
    feature_team_cur <- feature_team_cur[!feature_team_cur$next_team %in% c(team1, team2), ];
    feature_team_cur <- rbind(feature_team_cur, computeFeatureTeamList(feature_players_cur, c(team1, team2), c(2012)));
    val <- evaluateTeam(feature_team_cur, model, team);
    return(val);
}

getValue <- function(team){
    val <- evaluateTeam(feature_team_cur,model,team);
    return(val);
}

swap2 <- function(feature,player1,player2){
    feature <<- swapPlayers(feature,140,535)
}

swap <- function(player1,team1,player2,team2){
    message("Swapping")
    print(player1)
    print(player2)
    #feature_players_cur <<- players_clusters[players_clusters$season_year==2012,];
    #feature_team_cur <<- feature_team[feature_team$season_year==2012,];
    
    feature_players_cur <<- swapPlayers(feature_players_cur, player1, player2);
    #feature_players_cur <<- swapPlayers(feature_players_cur,140,535)
    feature_team_cur <<- feature_team_cur[!feature_team_cur$next_team %in% c(team1, team2), ];
    feature_team_cur <<- rbind(feature_team_cur, computeFeatureTeamList(feature_players_cur, c(team1, team2), c(2012)));
}


    

# Function: getPlayerIndex
# ========================
# Get player index of team

playerIndex <- function(teamName,teamPos){
    players <- which(feature_players_cur$next_team == teamName & feature_players_cur$position == teamPos);
    return(players);
}

##### Code originally in Python #######

createTeams <- function(teamNames,pos){
    allTeams = c()
    for(teamName in teamNames){
        message(teamName)
        names <- playerIndex(teamName,pos)
        temp <-c(list(names))
        names(temp) <- c(teamName)
        allTeams <- c(allTeams,temp)
    }
    return(allTeams)
}

dfs <- function(myTeam, otherTeams, pastTrades, depth){
    
    if(depth == MAX_DEPTH){
        cost <- getValue(myTeamName);
        print(cost)
        if(solutions[["bestWin"]] < cost){
            solutions <- c("bestWin" = cost);
        }
        else{
            if(solutions[["bestWin"]] == cost){
                temp <-c(cost);
                names(temp) <- c(pastTrades);
                solutions <- c(solutions,temp);
            }
        }
        return();
    }

    
    #for(name in names(allTeams)){
    #    myTeam <- 
    #    print(name); 
    #    print(allTeams[[name]])
    #}

    for(player in myTeam[[myTeamName]]){
        myPlayerIndex <- getPlayerIndex(myTeam,player,myTeamName)
        myTeam <- removePlayer(myTeam,player,myTeamName)

        for(otherTeamName in names(allTeams)){
            for(otherPlayer in allTeams[[otherTeamName]]){

                #Swap Players
                otherPlayerIndex <- getPlayerIndex(otherTeams,otherPlayer,otherTeamName)
                otherTeams <- removePlayer(otherTeams,otherPlayer,otherTeamName)
               

                # This would allow us to reswap with player we just traded, not necessary
                #otherTeams[teamName].insert(otherPlayerIndex,player)
                myTeam <- addPlayer(myTeam,otherPlayer,myTeamName,myPlayerIndex)
                swap(player,myTeamName,otherPlayer,otherTeamName)
                #newTrade
                dfs(myTeam,otherTeams,pastTrades,depth+1)

                #Undo Swap
                swap(player,myTeamName,otherPlayer,otherTeamName)
                #otherTeams[teamName].remove(player)
                otherTeams <- addPlayer(otherTeams,otherPlayer,otherTeamName,otherPlayerIndex)
                myTeam <- removePlayer(myTeam,otherPlayer,myTeamName)
            }
        }
        myTeam <- addPlayer(myTeam,player,myTeamName,myPlayerIndex)
    }

}

getPlayerIndex <- function(allTeamList,playerNum,teamName){
    temp <- allTeamList[[teamName]]
    index <- which(temp == playerNum)
    return(index)
}

removePlayer <- function(allTeamList,playerNum,teamName){
    temp <- allTeamList[[teamName]]
    temp <- temp[-which(temp == playerNum)]
    teamIndex <- which(names(allTeamList) == teamName)
    allTeamList <- allTeamList[-teamIndex]
    tempTeam <- list(temp)
    names(tempTeam) <- c(teamName)
    allTeamList <- append(allTeamList,tempTeam,teamIndex-1)
}

addPlayer <- function(allTeamList,playerNum,teamName,index){
   temp <- allTeamList[[teamName]]
   temp <- append(temp,playerNum,index-1)
   teamIndex <- which(names(allTeamList) == teamName)
   allTeamList <- allTeamList[-teamIndex]
   tempTeam <- list(temp)
   names(tempTeam) <- c(teamName)
   allTeamList <- append(allTeamList,tempTeam,teamIndex-1)
}

# Constants
MAX_DEPTH <- 1
pos <- "WR"
teamNames <- list("ARI","ATL","BAL")
myTeamName <- "ARI"
currWin <- getValue(myTeamName)
print(currWin)
solutions <- c('bestWin'=currWin)

# Get All Teams
allTeams <- createTeams(teamNames,pos)

# Create my Team
myTeam <- list(allTeams[[myTeamName]])
names(myTeam) <- c(myTeamName)

# Remove my Team from All Teams
allTeams <- allTeams[-which(names(allTeams) == myTeamName)]
message("Starting dfs")
dfs(myTeam,allTeams,c("hello"),0)
