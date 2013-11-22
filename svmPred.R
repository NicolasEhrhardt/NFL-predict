#!/usr/bin/Rscript

# change path to ./data
wd <- getwd()
setwd(paste(wd, "/data", sep=""))

# Parameters
trainModel = F # if set to F will load the model from modelFile
timeErrorPlot = T
askForSave = T
computeFeature = F

modelFile = "trainSvmAll.RData"
featureFile = "sumFeature.RData"

# load in vectors
file_players = "./DataAll_Agg.csv"
file_games = "./GameDataAll.csv"

message("Loading data...")
if(computeFeature) {

# load vectors
  players <- read.csv(file_players, header=T)
  games <- read.csv(file_games, header=T)
  y <- games$winning

  feature_team <- aggregate(. ~ team + season_year, data=players, FUN=sum);
# cleaning
  feature_team$player_id_orig <- NULL;
  feature_team$full_name <- NULL;
  feature_team$position <- NULL;
  feature_team$player_id <- NULL;

# creating feature vector for teams
  x = list();
  ngames = nrow(games);
  for(game in 1:ngames) {
    if(game %% round(ngames / 10) == 0) {
      message(paste(ceiling(game / ngames * 100), "%"));
    }

    row <- cbind(
      feature_team[feature_team$team==games$home_team[game] & feature_team$season_year==games$season_year[game], -c(1, 2)],
      feature_team[feature_team$team==games$away_team[game] & feature_team$season_year==games$season_year[game], -c(1, 2)]
    );
    x <- rbind(x, row)
  }

  save(x, y, file=featureFile);

} else {
  load(featureFile);  
}
message("-> Done Loading data")

# keeping sample
holdout = sample(nrow(x), nrow(x)/5);
xtrain = x[-holdout,]
ytrain = y[-holdout]

xtest = x[holdout,]
ytest = y[holdout]



if(trainModel) {
# train data using SVM
  message("Training model...")
  library(LiblineaR)
  model = LiblineaR(data=xtrain, labels=ytrain);

# computing error
  p = predict(model, xtrain);

# global error
  err = sum(abs(p$predictions - ytrain)/2)/nrow(games);
  message(paste("Training error:", err));

# displaying confusion table
  message("Confusion table:")
  res = table(p$predictions,ytrain)
  print(res)
  message("-> Done training model")
} else {
  message("Loading model...")
  load(modelFile);
  message("-> Done loading model")
}

if(timeErrorPlot) {
  message("Plotting train and test error...")

  library(LiblineaR)
  n = nrow(xtrain);
  samples = seq(n/30, n, n/30);
  errTrainList = list();
  errTestList = list();
  for(i in samples) {
    modi <- LiblineaR(data=xtrain[1:i,], labels=ytrain[1:i]);

# computing error
    predTrain <- predict(modi, xtrain[1:i,]);
    predTest <- predict(modi, xtest);

    errTrainList <- rbind(errTrainList, sum(abs(predTrain$predictions - ytrain[1:i])/2)/i);
    errTestList <- rbind(errTestList, sum(abs(predTest$predictions - ytest)/2)/length(ytest));
  } 
  X11()
# png("svm-train-error.png")
  plot(samples, errTrainList, 
    ylim=range(errTrainList, errTestList), 
    type="b", col="green", 
    xlab="Training examples", ylab="Error");
  lines(samples, errTestList, 
    type="b", col="red");
  legend("bottomright", legend=c("Training Error", "Test Error"), pch="oo", col=c("green", "red"));
  
  message("-> Done. Continue? [ENTER]")
  invisible(readLines("stdin", n=1))
  #dev.off()
}

if(askForSave & trainModel) {
  message("Do you want to save the model? (y/n) ")
  ans <- readLines("stdin", n=1)
  if(ans == "y") {
    save(model, file=modelFile);
    message(paste("File saved at", modelFile));
  }
}
