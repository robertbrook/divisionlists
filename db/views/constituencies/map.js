var constituencies = "|";

function(doc) {
  if (doc.ayes != "") {
    for (var i in doc.ayes) {
      if (doc.ayes[i]["constituency"] != "" && is_unique(doc.ayes[i]["constituency"])) {
        emit([doc._id, doc.ayes[i]["constituency"]], doc.ayes[i]["constituency"]);
        constituencies += doc.ayes[i]["constituency"] + "|";
      }
    }
  }
  
  if (doc.noes != "") {
    for (var i in doc.noes) {
      if (doc.noes[i]["constituency"] != "" && is_unique(doc.noes[i]["constituency"])) {
        emit([doc._id, doc.noes[i]["constituency"]], doc.noes[i]["constituency"]);
        constituencies += doc.noes[i]["constituency"] + "|";
      }
    }
  }
}

function is_unique(constituency) {
  return (constituencies.indexOf("|" + constituency + "|") < 0);
}