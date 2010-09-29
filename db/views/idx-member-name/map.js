function(doc) {
  var words_used = "|";
  var tokens;
  
  if (doc.noes) {
    for (voter in doc.noes) {
      votename = doc.noes[voter].forename + " " + doc.noes[voter].surname;
      tokens = votename.split(/[^A-Z0-9\-_]+/i);
      for (word in tokens) {
        keyword = tokens[word].toLowerCase();
        if (words_used.indexOf("|" + keyword + "|") < 0) {
          if (keyword.length > 1) {
            emit(keyword, {"id": doc._id, "number":doc.number.replace(/Numb(,|\.)/, "").replace(/,|\./,"").replace(" ", "")});
            words_used = words_used + keyword + "|";
          }
        }
      }
      
      //emit the whole votename
      votename = trim(votename.toLowerCase());
      if (words_used.indexOf("|" + votename + "|") < 0) {
        if (votename != "" && votename != "???") {
          emit(votename, {"id": doc._id, "number":doc.number.replace(/Numb(,|\.)/, "").replace(/,|\./,"").replace(" ", "")});
          words_used = words_used + votename + "|";
        }
      }
    }
  }
  
  if (doc.ayes) {
    for (voter in doc.ayes) {
      votename = doc.ayes[voter].forename + " " + doc.ayes[voter].surname;
      tokens = votename.split(/[^A-Z0-9\-_]+/i);
      for (word in tokens) {
        keyword = tokens[word].toLowerCase();
        if (words_used.indexOf("|" + keyword + "|") < 0) {
          if (keyword.length > 1) {
            emit(keyword, {"id": doc._id, "number":doc.number.replace(/Numb(,|\.)/, "").replace(/,|\./,"").replace(" ", "")});
            words_used = words_used + keyword + "|";
          }
        }
      }
      
      //emit the whole votename
      votename = trim(votename.toLowerCase());
      if (words_used.indexOf("|" + votename + "|") < 0) {
        if (votename != "" && votename != "???") {
          emit(votename, {"id": doc._id, "number":doc.number.replace(/Numb(,|\.)/, "").replace(/,|\./,"").replace(" ", "")});
          words_used = words_used + votename + "|";
        }
      }
    }
  }
}

function trim(input_string) {
  output = input_string.replace(/^\s+/, "").replace(/\s+$/, "");
  return output;
}