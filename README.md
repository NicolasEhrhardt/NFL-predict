NFL-Predict
===========

When two CS students play with NFL data.


Scripts
=======

Linear regression
-----------------

Is a simple regression done in matlab.

    >  linregAnalysis('data/WRDataAll.csv')


Victory prediction by SVM
-------------------------

Predicts the likeliness of a team to win over another one only based on its Wide Receivers. For now the data includes all the matches done from 2010 to 2012.

### Requirements

* R

### Launching

    $  chmod ug+x svmPred.R
    $  ./svmPred.R

The R script plots the confusion matrix when training on the full training set. It also plots the training and dev error, and enables you to save the model into a file (so as not to have to train it again). (all of these options can be enabled/disable in the beginning of the script).

nb: R is using Liblinear which will be installed the first time you run the script, it is the intended behavior.
