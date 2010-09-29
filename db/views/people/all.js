var namerefs = "|";

function(doc) {
	if (doc.ayes != "") {
		for (var i in doc.ayes) {
			if (doc.ayes[i]["surname"] != "") {
				name = doc.ayes[i]["title"] + " " + doc.ayes[i]["forename"] + " " + doc.ayes[i]["surname"];
				name = trim(name);
				if (is_unique("|" + name + " " + doc.numeric_date[0] + "|")) {
					emit([doc._id, name], [name, doc.ayes[i]["constituency"], doc.numeric_date[0]]);
					namerefs = namerefs + name + " " + doc.numeric_date[0] + "|";
				}
			}
		}
	}
	
	if (doc.noes != "") {
		for (var i in doc.noes) {
			if (doc.noes[i]["surname"] != "") {
				name = doc.noes[i]["title"] + " " + doc.noes[i]["forename"] + " " + doc.noes[i]["surname"];
				name = trim(name);
				if (is_unique("|" + name + " " + doc.numeric_date[0] + "|")) {
					emit([doc._id, name], [name, doc.noes[i]["constituency"], doc.numeric_date[0]]);
					namerefs = namerefs + name + " " + doc.numeric_date[0] + "|";
				}
			}
		}
	}
}

function trim(input_string) {
	output = input_string.replace(/^\s+/, "").replace(/\s+$/, "");
	return output;
}

function is_unique(input_string) {
	return (namerefs.indexOf(input_string) < 0);
}