function(doc) {
	var words_used = "|"
	var tokens;
	
	if (doc.noes) {
		for (voter in doc.noes) {
			constituency = doc.noes[voter].constituency;
			tokens = constituency.split(/[^A-Z0-9\-_]+/i);
			for (word in tokens) {
				keyword = tokens[word].toLowerCase();
				if (words_used.indexOf("|" + keyword + "|") < 0) {
					if (keyword.length > 1) {
						emit(keyword, {"id": doc._id, "number":doc.number.replace(/Numb(,|\.)/, "").replace(/,|\./,"").replace(" ", "")});
						words_used = words_used + keyword + "|";
					}
				}
			}
			
			//emit the full constituency name
			constituency = constituency.toLowerCase();
			if (words_used.indexOf("|" + constituency + "|") < 0) {
				if (constituency != "" && constituency != "???") {
					emit(constituency, {"id": doc._id, "number":doc.number.replace(/Numb(,|\.)/, "").replace(/,|\./,"").replace(" ", "")});
					words_used = words_used + constituency + "|";
				}
			}
		}
	}
	
	if (doc.ayes) {
		for (voter in doc.ayes) {
			constituency = doc.ayes[voter].constituency;
			tokens = constituency.split(/[^A-Z0-9\-_]+/i);
			for (word in tokens) {
				keyword = tokens[word].toLowerCase();
				if (words_used.indexOf("|" + keyword + "|") < 0) {
					if (keyword.length > 1) {
						emit(keyword, {"id": doc._id, "number":doc.number.replace(/Numb(,|\.)/, "").replace(/,|\./,"").replace(" ", "")});
						words_used = words_used + keyword + "|";
					}
				}
			}
			
			//emit the full constituency name
			constituency = constituency.toLowerCase();
			if (words_used.indexOf("|" + constituency + "|") < 0) {
				if (constituency != "" && constituency != "???") {
					emit(constituency, {"id": doc._id, "number":doc.number.replace(/Numb(,|\.)/, "").replace(/,|\./,"").replace(" ", "")});
					words_used = words_used + constituency + "|";
				}
			}
		}
	}
}