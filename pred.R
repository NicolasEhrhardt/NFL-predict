#!/usr/bin/Rscript

# Parameters

# Features
computeFeature = T
featureSave = T
featureFile = "model/logreg-feat-4k-ind-summean-mergepos.RData"

k = 4
distKmeans = F
indKmeans = T
polyDeg = 1

# Training
trainModel = T # if set to F will load the model from modelFile

# Chosen models
svmModel = F
linregModel = T

modelSave = T
modelFile = "model/logreg-4k-ind-summean-mergepos.RData"

# Analysis
crossvalidationErr = T
timeErrorPlot = T
graphSave = T
graphFile = "img/logreg-err-4k-ind-summean-mergepos.png"

# load in vectors
file_players = "data/DataAll_Agg_v3.csv"
file_historyplayers = "data/HistoryPlayerAll.csv"
file_games = "data/GameDataAll.csv"

message("+-> Loading data...")

# load vectors
players <- read.csv(file_players, header=T)
historyplayers <- read.csv(file_historyplayers, header=T)
games <- read.csv(file_games, header=T)
# Deleting unusable seasons
games <- games[!(games$season_year == 2009),];
y <- games$winning;

library(LiblineaR)
library(e1071)

######################
## Function library ##
######################

source("func.R")

######################
## Compute features ##
######################

if(computeFeature) {
  # players_cleaned contains all the stats
  players_cleaned = players;
  
  # cleaning (removing useless string fields)
  players_cleaned$full_name <- NULL;
  players_cleaned$player_id_orig <- NULL;
  message("-> Precomputing done.")
  
  # svm cle_cleanedanup
  if (svmModel) {
    players_cleaned$kicking_all_yds <- NULL;
    players_cleaned$kicking_downed  <- NULL;
    players_cleaned$kicking_rec_tds <- NULL;
    players_cleaned$kickret_oob     <- NULL;
    players_cleaned$kickret_touchback <- NULL;
    players_cleaned$puntret_downed  <- NULL;
    players_cleaned$puntret_oob     <- NULL;
    players_cleaned$puntret_touchback <- NULL;
    players_cleaned$rushing_loss    <- NULL;
    players_cleaned$rushing_loss_yds <- NULL;
  }

  # Raw positions
  # positions <- unique(players_cleaned$position);
  
  # Grouped positions
  # - Offensive Line "C" Center "G" Guard "OT" 
  # - Offensive Tackle "T" tackle "OG" Offensive Guard 
  # - Defensive Line "DT" Defensive tackle "NT" Nose tackle
  # - Safety "SAF" Safety "SS" Strong Safety "FS" Free safety
  # - Drop "P" Punter "UNK" Unkown "LS" Long snapper "K" Kicker 
  # - Line backer "ILB" Inside Line backer "OLB" Outside Line backer "LB" Line backer "MLB" Middle Line Backer
  # - Left by themselves "CB" Cornerback "DB" Defensive back "DE" Defensive end "FB" Full back "QB" Quarterback "RB" Running back "TE" Tight End "WR Wide Receiver
  positions <- list( 
    c("C", "G", "OT"), 
    c("T", "OG"),
    c("DT", "NT"), 
    c("SAF", "SS", "FS"),
    c("P", "LS", "K"),
    c("ILB", "OLB", "LB", "MLB"),
    c("CB"),
    c("DB"),
    c("DE"),
    c("FB"),
    c("QB"),
    c("RB"),
    c("TE"),
    c("WR"),
    c("UNK")
  )

  # Computing clusters
  if(k > 0) {
    for (position in positions) {
     # if (!(position %in% c("NA", "OG", "OT", "SAF", "UNK"))) {
        message("-> Clustering position: ", position[1])
        predkmeans <- kmeans(players_cleaned[which(players_cleaned$position %in% position), !(colnames(players_cleaned) %in% c("team", "position","season_year", "next_team", "player_id")), drop=F], k);
        
        if(distKmeans) {
          players_cleaned[, paste(position[1], 1:k, sep=".D.")] <- 0;
          for(player in which(players_cleaned$position %in% position)) {
            tot <- 0.;
            for(cluster in 1:k) {
              dist <- sqrt(sum((predkmeans$centers[cluster,] - players_cleaned[player, !(colnames(players_cleaned) %in% c("team", "position","season_year", "next_team", "player_id"))])^2));
              players_cleaned[player, paste(position[1], cluster, sep=".D.")] <- dist;
              tot <- tot + dist;
            }

            # normalizing
            players_cleaned[player, paste(position[1], 1:k, sep=".D.")] <- 1 - players_cleaned[player, paste(position[1], 1:k, sep=".D.")] / tot;
            players_cleaned[player, paste(position[1], 1:k, sep=".D.")] <- players_cleaned[player, paste(position[1], 1:k, sep=".D.")] / sum(players_cleaned[player, paste(position[1], 1:k, sep=".D.")]);
          }
        } 
        if (indKmeans) {
          players_cleaned[, paste(position[1], 1:k, sep=".I.")] <- 0;
          for(cluster in 1:k) {
            players_cleaned[which(players_cleaned$position %in% position), paste(position[1], cluster, sep=".I.")] <- predkmeans$cluster == cluster;
          }
        }
    }
    message("-> Clustering done.")

    # Selecting only columns relative to the clusters (drop all the stats)
    feature_player <- players_cleaned[, append(
      which(colnames(players_cleaned) %in% c("player_id", "position", "next_team", "season_year", "nbplays"))
      , grep("\\.", colnames(players_cleaned), perl=T))
    ];
  } else {
    feature_player <- players_cleaned;
  }

  # Computing features for each team
  feature_team <- computeFeatureTeamList(feature_player, unique(players$team), 2009:2012);
  message("-> Team features computed.")

  # creating feature vector for games based on the feature vector of the teams
  feature_team$next_team <- droplevels(feature_team$next_team);
  x = list();
  ngames = nrow(games);
  for(game in 1:ngames) {
    if(game %% round(ngames / 10) == 0) {
      message("-> Loading game: ", ceiling(game / ngames * 100), "%");
    }
    row <- computeGameFeature(
      feature_team[feature_team$next_team==games$home_team[game] & feature_team$season_year==games$season_year[game] - 1, -c(1, 2)],
      feature_team[feature_team$next_team==games$away_team[game] & feature_team$season_year==games$season_year[game] - 1, -c(1, 2)]
    );
    x <- rbind(x, row)
  }
  
  if(featureSave) {
    save(x, players_cleaned, feature_player, feature_team, file=featureFile);
    message("Features saved at ", featureFile)
  }
} else {
  load(featureFile);  
}
message(paste("--> Done Loading data, number of games: ", nrow(x)))

# keeping sample
holdout = sample(nrow(x), nrow(x)/10);
xtrain = x[-holdout,]
ytrain = y[-holdout]

xtest = x[holdout,]
ytest = y[holdout]

#################
## Train Model ##
#################

if(trainModel) {
  # train data using SVM
  message("+-> Training model...")
  
  if(linregModel) {
    model <- LiblineaR(data=xtrain, labels=ytrain, type=1);
    ptrain <- predict(model, xtrain);
    ptest <- predict(model, xtest);
    ymodtrain <- ptrain$predictions;
    ymodtest <- ptest$predictions;
  }
  if(svmModel) {
    model = svm(x=xtrain, y=ytrain, type="C-classification") #, scale = TRUE, kernel = "sigmoid", degree = 3, gamma = if (is.vector(x)) 1 else 1 / ncol(x), coef0 = 0, cost = 1, nu = 0.5);
    ptrain = predict(model, xtrain);
    ptest = predict(model, xtest);
    ymodtrain = ptrain;
    ymodtest = ptest;
  }

  # computing error
  # global error
  errTrain = sum(ymodtrain != ytrain)/length(ytrain);
  errTest = sum(ymodtest != ytest)/length(ytest);
  message(paste("Training error:", round(errTrain, 2), "| Dev error", round(errTest, 2)));

  # displaying confusion table
  message("Confusion train table:")
  restrain = table(ymodtrain ,ytrain)
  print(restrain)
  
  message("Confusion test table:")
  restest = table(ymodtest ,ytest)
  print(restest)  
  
  message("--> Done training model")
} else {
  message("+-> Loading model...")
  load(modelFile);
  message("--> Done loading model")
}

if(crossvalidationErr) {
  s = sample(nrow(x));
  err = 0;

  # compute cross validation
  for(i in 0:9) {
    holdout <- s[floor(i * nrow(x) / 10): floor((i+1) * nrow(x) / 10)];
    xcross <- x[-holdout,];
    ycross <- y[-holdout];

    xcrosstest <- x[holdout,];
    ycrosstest <- y[holdout];

    if(linregModel) {
      modelcross <- LiblineaR(data=xcross, labels=ycross);
      pcross <- predict(modelcross, xcrosstest);
      ymodcross <- pcross$predictions;
      err <- err + sum(ymodcross != ycrosstest);
    }
  }
  message("-> Average cross validation error: ", round(err / nrow(x) * 100, 2), "%")
}

###################
## Train/dev err ##
###################

if(timeErrorPlot) {
  message("+-> Plotting train and test error...")
  
  # for dev/test graph, step size == number of training example / 30
  n = nrow(xtrain);
  sizes = seq(n/30, n, n/30);
  
  errTrainList = list();
  errTestList = list();
  
  # compute error for each sample size
  for(i in sizes) {
    if(linregModel) {
      modi <- LiblineaR(data=xtrain[1:i,], labels=ytrain[1:i]);
      predTrain <- predict(modi, xtrain[1:i,]);
      predTest <- predict(modi, xtest);
      ymodi = predTrain$predictions;
      ytesti = predTest$predictions;
    }
    if(svmModel) {
      modi <- svm(x=xtrain[1:i,], y=ytrain[1:i], type="C-classification")#, scale = TRUE, kernel = "polynomial", degree = 2, gamma = 1, coef0 = 0, cost = 1, nu = 0.5);
      predTrain <- predict(modi, xtrain[1:i,]);
      predTest <- predict(modi, xtest);
      ymodi = predTrain;
      ytesti = predTest;
    }

    # computing error
    errTrainList <- rbind(errTrainList, sum(ymodi != ytrain[1:i])/i);
    errTestList <- rbind(errTestList, sum(ytesti != ytest)/length(ytest));
  } 
  if(!graphSave) {
    X11();
  } else {
    png(graphFile);
  }

  plot(sizes, errTrainList, 
    ylim=range(errTrainList, errTestList), 
    type="b", col="green", 
    xlab="Training examples", ylab="Error");
  lines(sizes, errTestList, 
    type="b", col="red");
  legend("bottomright", legend=c("Training Error", "Test Error"), pch="oo", col=c("green", "red"));
  if(graphSave) {
    dev.off();
    message("--> Image saved at: ", graphFile)
  }
  
  message("--> Done. Continue? [ENTER]")
  invisible(readLines("stdin", n=1))
}

################
## Save model ##
################

if(modelSave & trainModel) {
  message("+-> Do you want to save the model? (y/n) ")
  ans <- readLines("stdin", n=1)
  if(ans == "y") {
    save(model, file=modelFile);
    message(paste("--> Done. File saved at", modelFile));
  }
}


