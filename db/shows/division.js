function(doc, req) {  
  var ddoc = this;
  var Mustache = require("lib/mustache");

  var months = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"];
  var data = {};
  var archive_month = months[(doc.numeric_date[1] - 1)];
  
  if (doc) {
    data.number = doc.number;
    data.date = doc.date;
    data.page = doc.page;
    data.resolution = doc.resolution;
    data.archive_link = "http://hansard.millbanksystems.com/sittings/" + doc.numeric_date[0] + "/" + archive_month + "/" + doc.numeric_date[2];
    data.title = "Division " + doc.number + ", " + doc.numeric_date[0];
    data.votes_cast = doc.ayes.length + doc.noes.length;
    data.ayes_count = doc.ayes.length;
    data.noes_count = doc.noes.length;
    data.ayes_percent = Math.round(doc.ayes.length * 100 / data.votes_cast);
    data.noes_percent = Math.round(doc.noes.length * 100 / data.votes_cast);
    data.ayes = doc.ayes;
    data.noes = doc.noes;
    data.ayes_tellers = doc.ayes_tellers;
    data.noes_tellers = doc.noes_tellers;
  }
  
  return Mustache.to_html(ddoc.templates.division, data);
}