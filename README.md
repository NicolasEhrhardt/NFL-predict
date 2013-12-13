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

### Computing

    $  chmod ug+x pred.R
    $  ./pred.R

The R script has a lot of different options at the top that you should check out before running anything.

It can plot the confusion matrix when training on the full training set. It can also plot the training and dev error, and enables you to save the model into a file (so as not to have to train it again). (all of these options can be enabled/disable in the beginning of the script).

### About

* R is using Liblinear which will be installed the first time you run the script, it is the intended behavior.

* The percentage feature are quite slow to compute

* ``func.R`` is used as an external library, it contains the aggregation logic per team, that is the place to go to change the aggregation logic.


Creating a good team
--------------------

### Requirements

* R

* R2Py

### Executing

    $ python createTeam3.py

### About

* The script is linked to the R prediction part through the file ``search2.R`` which contains binders to the R objects.

* The current version processes only a subset of possible swap due to a very poor performance of the feature extractors.


Folders organization
--------------------

* ``img/`` contains graphs used to analyze the machine learning part efficiency.

* ``model/`` includes features and model computed in the past that can be reloaded without having to recompute them.

* ``data/`` contains the data extracted from the postgreSQL database (the scrapped data was previously stored there)

* ``query/`` stores the query used to clean and extract our dataset from the database

* ``scraper/`` hosts the nodejs script used to scrape data from the third party website
