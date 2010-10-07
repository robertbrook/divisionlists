function(doc) {
  var ret=new Document();
  
  ret.add(doc.numeric_date[0], {"field":"year", "index":"no", "store":"yes"})
  ret.add(doc.number.replace(/Numb(,|\.)?/, "").replace(/,|\./,"").replace(" ", ""), {"field":"number", "index":"no", "store":"yes"})
  
  ret.add(doc.resolution);
  ret.add(doc.resolution, {"field":"resolution"});
  
  //loop through the ayes and pull out indexable fields
  for (var i=0; i < doc['ayes'].length; i++) {
    rec = doc['ayes'][i];
    //constituency
    if (rec.constituency && rec.constituency != "") {
      ret.add(rec.constituency)
      ret.add(rec.constituency, {"field":"constituency"});
    }
    //surname
    if (rec.surname && rec.surname != "") {
      ret.add(rec.surname)
      ret.add(rec.surname, {"field":"surname"});
    }
    //forename
    if (rec.forename && rec.forename != "") {
      ret.add(rec.forename)
      ret.add(rec.forename, {"field":"forename"});
    }
    //title
    if (rec.title && rec.title != "") {
      ret.add(rec.title)
      ret.add(rec.title, {"field":"title"});
    }
  }
  
  //loop through the noes and pull out indexable fields
  for (var i=0; i < doc['noes'].length; i++) {
    rec = doc['noes'][i];
    //constituency
    if (rec.constituency && rec.constituency != "") {
      ret.add(rec.constituency)
      ret.add(rec.constituency, {"field":"constituency"});
    }
    //surname
    if (rec.surname && rec.surname != "") {
      ret.add(rec.surname)
      ret.add(rec.surname, {"field":"surname"});
    }
    //forename
    if (rec.forename && rec.forename != "") {
      ret.add(rec.forename)
      ret.add(rec.forename, {"field":"forename"});
    }
    //title
    if (rec.title && rec.title != "") {
      ret.add(rec.title)
      ret.add(rec.title, {"field":"title"});
    }
  }
  
  return ret;
}