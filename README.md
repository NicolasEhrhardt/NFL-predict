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

Predicts the likeliness of a team to win over another one only based on its Wide Receiver. For now the data includes all the match done from 2010 to 2012.

### Requirements

* R

### Launching

    >  chmod ug+x svmPred.R
    >  ./svmPred.R

The R script plots the confusion matrix when training on the full training set. It also plots the training and dev error, and enables you to save the model into a file. (all of these options can be enabled/disable in the beginning of the script).
