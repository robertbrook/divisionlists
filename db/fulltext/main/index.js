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
      ret.add(rec.constituency);
      ret.add(rec.constituency, {"field":"constituency"});
    }
    
    var surname = "";
    //surname
    if (rec.surname && rec.surname != "") {
      var surname = rec.surname;
    }
    //forename
    if (rec.forename && rec.forename != "") {
      ret.add(rec.forename + " " + surname);
      ret.add(rec.forename + " " + surname, {"field":"name"});
      ret.add(rec.forename + " " + surname, {"field": "aye"});
    } else {
      ret.add(surname, {"field":"name"});
      ret.add(surname, {"field":"aye"});
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
    var surname = "";
    //surname
    if (rec.surname && rec.surname != "") {
      surname = rec.surname;
    }
    //forename
    if (rec.forename && rec.forename != "") {
      ret.add(rec.forename + " " + surname);
      ret.add(rec.forename + " " + surname, {"field":"name"});
      ret.add(rec.forename + " " + surname, {"field":"noe"});
    } else {
      ret.add(surname, {"field":"name"});
      ret.add(surname, {"field":"noe"});
    }
    //title
    if (rec.title && rec.title != "") {
      ret.add(rec.title);
      ret.add(rec.title, {"field":"title"});
    }
  }
  
  return ret;
}