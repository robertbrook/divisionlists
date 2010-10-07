function(doc) {
  emit(doc.numeric_date[0] + "-" + doc.number.replace(/Numb(,|\.)?/, "").replace(/,|\./,"").replace(" ", ""), doc);
}