require 'db_helper'
require 'rubygems'
require 'rest_client'

doc = '{
   "_id": "_design/people",
   "language": "javascript",
   "views": {
       "all": {
           "map": "var namerefs = \"|\";\n\nfunction(doc) {\n  if (doc.ayes != \"\") {\n    for (var i in doc.ayes) {\n      if (doc.ayes[i][\"surname\"] != \"\") {\n\tname = doc.ayes[i][\"title\"] + \" \" + doc.ayes[i][\"forename\"] + \" \" + doc.ayes[i][\"surname\"];\n        name = trim(name);\n        if (is_unique(\"|\" + name + \" \" + doc.numeric_date[0] + \"|\")) {\n          emit([doc._id, name], [name, doc.ayes[i][\"constituency\"], doc.numeric_date[0]]);\n          namerefs = namerefs + name + \" \" + doc.numeric_date[0] + \"|\";\n        }\n      }\n    }\n  }\n\n  if (doc.noes != \"\") {\n    for (var i in doc.noes) {\n      if (doc.noes[i][\"surname\"] != \"\") {\n        name = doc.noes[i][\"title\"] + \" \" + doc.noes[i][\"forename\"] + \" \" + doc.noes[i][\"surname\"];\n        name = trim(name);\n        if (is_unique(\"|\" + name + \" \" + doc.numeric_date[0] + \"|\")) {\n          emit([doc._id, name], [name, doc.noes[i][\"constituency\"], doc.numeric_date[0]]);\n          namerefs = namerefs + name + \" \" + doc.numeric_date[0] + \"|\";\n        }\n      }\n    }\n  }\n}\n\nfunction trim(input_string) {\n  output = input_string.replace(/^\\s+/, \"\").replace(/\\s+$/, \"\");\n  return output;\n}\n\nfunction is_unique(input_string) {\n  return (namerefs.indexOf(input_string) < 0);\n}"
       }
   }
}'

result = RestClient.put("#{DATABASE}/_design%2Fpeople", doc)

p result