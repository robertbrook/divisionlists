function(doc) {
  var words_used = "|";
  var tokens;
  
  if (doc.resolution) {
    tokens = doc.resolution.split(/[^A-Z0-9\-_]+/i);
    for (word in tokens) {
      keyword = tokens[word].toLowerCase();
      if (words_used.indexOf("|" + keyword + "|") < 0) {
        if (keyword.length > 3) {
          emit(keyword, {"id": doc._id, "number":doc.number.replace(/Numb(,|\.)/, "").replace(/,|\./,"").replace(" ", "")})
          words_used = words_used + keyword + "|";
        }
      }
    }
  }
}