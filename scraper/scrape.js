var http = require('http');
var jsdom = require('jsdom')
var fs = require('fs');

var url = 'http://www.pro-football-reference.com/teams/gnb/2012_injuries.htm';
var urlBase = 'http://www.pro-football-reference.com';
var folder = './data/';
var years = ['2012', '2011', '2010'];

loadTeams(urlBase, years);

function loadTeams(loadUrlBase, loadYear) {
  jsdom.env(
    "http://www.pro-football-reference.com/teams/",
    ["http://code.jquery.com/jquery.js"],
    function (errors, window) {
      tableRows = window.$("#teams_active tbody tr")
      window.$(tableRows).each(function() {
        var teamUrl = window.$(this).children(':first').children('a').attr('href');
        var teamName = teamUrl.split('/')[2];
        loadYear.forEach(function(year) {
          console.log('Loading team ' + teamName + ' for year ' + year);
          scrapeTableToFile(loadUrlBase + teamUrl + year + '_injuries.htm', '.injury_table', folder + teamName + year + '.csv', year);
        });
      });
    }
  );
}

function scrapeTableToFile(url, table, file, prefix) {
  jsdom.env(
    url,
    ["http://code.jquery.com/jquery.js"],
    function (errors, window) {
        var tableRows = window.$(table + " tr");
        var csv = "";
        var first = true;
        window.$(tableRows).each(function(){
          //no first row
          if(first) {
            first = false;
            return;
          }
          if(typeof(prefix) != "unassigned") {
            csv = csv + prefix + ',';
          }
          window.$(this).children('td').each(function(){
            csv = csv + "\"" + window.$.trim(window.$(this).text()) + "\",";
          });
          csv = csv.substr(0, csv.length-1);
          csv = csv + "\n";
        });
      writeToFile(file, csv);
    }
  );
}

function writeToFile(file, text) {
  fs.writeFile(file, text, function(err) {
    if(err) {
      console.log(err);
    } else {
      console.log("File saved: " + file);
    }
  });
}
