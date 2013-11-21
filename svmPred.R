#!/usr/bin/Rscript

# change path to ./data
wd <- getwd()
setwd(paste(wd, "/data", sep=""))

# plot parameters
timeErrorPlot <- T

# load in vectors
file_players <- "./WRDataAll_Agg.csv"
file_games <- "./GameDataAll.csv"

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
for(game in 1:nrow(games)) {
  row <- cbind(
    feature_team[feature_team$team==games$home_team[game] & feature_team$season_year==games$season_year[game],-1],
    feature_team[feature_team$team==games$away_team[game] & feature_team$season_year==games$season_year[game], -1]
  );
  x <- rbind(x, row)
}

# train data using SVM
library(LiblineaR)
model = LiblineaR(data=x, labels=y);

# computing error
p = predict(model, x);

# global error
err = sum(abs(p$predictions - y)/2)/nrow(games);
print(paste("Training error:", err));

# displaying confusion table
print("Confusion table:")
res = table(p$predictions,y)
print(res)

if(timeErrorPlot) {

ngames = nrow(games)
samples = seq(ngames/30, ngames, ngames/30);
errList = list();
for(i in samples) {
  modi <- LiblineaR(data=x[1:i,], labels=y[1:i]);

  # computing error
  pred <- predict(modi, x);

  errList <- rbind(errList, sum(abs(pred$predictions - y)/2)/ngames);
} 
print(errList)
X11()
plot(samples, errList, type="b", xlab="Training examples", ylab="Error");
message("Press Return To Continue")
invisible(readLines("stdin", n=1))
dev.off()
}
