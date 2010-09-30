function(doc) {
  emit(doc.number.replace(/Numb(,|\.)?/, "").replace(/,|\./,"").replace(" ", ""), doc);
}