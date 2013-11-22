#!/usr/bin/Rscript

# change path to ./data
wd <- getwd()
setwd(paste(wd, "/data", sep=""))

# Parameters

# Features
computeFeature = F
featureFile = "sumDiffFeature.RData"

# Training
trainModel = T # if set to F will load the model from modelFile
svmTrain = T
linregTrain = F

# Analysis
timeErrorPlot = T
graphSave = T
graphName = "SVM-train.png"

modelSave = T
modelFile = "trainSVMAll.RData"

# load in vectors
file_players = "./DataAll_Agg.csv"
file_games = "./GameDataAll.csv"

message("+> Loading data...")

# load vectors
players <- read.csv(file_players, header=T)
games <- read.csv(file_games, header=T)
y <- games$winning

######################
## Compute features ##
######################

if(computeFeature) {
  feature_team <- aggregate(. ~ team + season_year, data=players, FUN=sum);
# cleaning
  feature_team$player_id_orig <- NULL;
  feature_team$full_name <- NULL;
  feature_team$position <- NULL;
  feature_team$player_id <- NULL;
# svm cleanup
  feature_team$kicking_all_yds <- NULL;
  feature_team$kicking_downed <- NULL;
  feature_team$kicking_rec_tds <- NULL;
  feature_team$kickret_oob <- NULL;
  feature_team$kickret_touchback <- NULL;
  feature_team$puntret_downed <- NULL;
  feature_team$puntret_oob <- NULL;
  feature_team$puntret_touchback <- NULL;
  feature_team$rushing_loss <- NULL;
  feature_team$rushing_loss_yds <- NULL;

  extractFeature <- function(featTeamHome, featTeamAway) {
    return(featTeamHome - featTeamAway);
  }

# creating feature vector for teams
  x = list();
  ngames = nrow(games);
  for(game in 1:ngames) {
    if(game %% round(ngames / 10) == 0) {
      message(paste(ceiling(game / ngames * 100), "%"));
    }

    row <- extractFeature(
      feature_team[feature_team$team==games$home_team[game] & feature_team$season_year==games$season_year[game], -c(1, 2)],
      feature_team[feature_team$team==games$away_team[game] & feature_team$season_year==games$season_year[game], -c(1, 2)]
    );
    x <- rbind(x, row)
  }

  save(x, file=featureFile);

} else {
  load(featureFile);  
}
message("-> Done Loading data")

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
  message("+> Training model...")
  
  if(linregTrain) {
    library(LiblineaR)
    model = LiblineaR(data=xtrain, labels=ytrain, type=1);
    ptrain = predict(model, xtrain);
    ptest = predict(model, xtest);
    ymodtrain = ptrain$predictions;
    ymodtest = ptest$predictions;
  }
  if(svmTrain) {
    library(e1071)
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
  
  message("-> Done training model")
} else {
  message("Loading model...")
  load(modelFile);
  message("-> Done loading model")
}

###################
## Train/dev err ##
###################

if(timeErrorPlot) {
  message("+> Plotting train and test error...")
  
  n = nrow(xtrain);
  samples = seq(n/30, n, n/30);
  
  errTrainList = list();
  errTestList = list();
  
  for(i in samples) {
    if(linregTrain) {
      library(LiblineaR)
      modi <- LiblineaR(data=xtrain[1:i,], labels=ytrain[1:i]);
      predTrain <- predict(modi, xtrain[1:i,]);
      predTest <- predict(modi, xtest);
      ymodi = predTrain$predictions;
      ytesti = predTest$predictions;
    }
    if(svmTrain) {
      library(e1071)
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
    png("svm-train-error.png");
  }

  plot(samples, errTrainList, 
    ylim=range(errTrainList, errTestList), 
    type="b", col="green", 
    xlab="Training examples", ylab="Error");
  lines(samples, errTestList, 
    type="b", col="red");
  legend("bottomright", legend=c("Training Error", "Test Error"), pch="oo", col=c("green", "red"));
  if(graphSave)
    dev.off();
  
  message("-> Done. Continue? [ENTER]")
  invisible(readLines("stdin", n=1))
}

################
## Save model ##
################

if(modelSave & trainModel) {
  message("+> Do you want to save the model? (y/n) ")
  ans <- readLines("stdin", n=1)
  if(ans == "y") {
    save(model, file=modelFile);
    message(paste("-> Done. File saved at", modelFile));
  }
}
