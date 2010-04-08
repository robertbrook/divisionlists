require 'db_helper'
require 'rubygems'
require 'rest_client'

doc = '{
   "_id": "_design/constituencies",
   "language": "javascript",
   "views": {
       "all": {
           "map": "var constituencies = \"|\";\n\nfunction(doc) {\n  if (doc.ayes != \'\') {\n    for (var i in doc.ayes) {\n      if (doc.ayes[i][\"constituency\"] != \"\" && is_unique(doc.ayes[i][\"constituency\"])) {\n        emit([doc._id, doc.ayes[i][\"constituency\"]], doc.ayes[i][\"constituency\"]);\n        constituencies += doc.ayes[i][\"constituency\"] + \"|\";\n      }\n    }\n  }\n\n  if (doc.noes != \'\') {\n    for (var i in doc.noes) {\n      if (doc.noes[i][\"constituency\"] != \"\" && is_unique(doc.noes[i][\"constituency\"])) {\n        emit([doc._id, doc.noes[i][\"constituency\"]], doc.noes[i][\"constituency\"]);\n        constituencies += doc.noes[i][\"constituency\"] + \"|\";\n      }\n    }\n  }\n}\n\nfunction is_unique(constituency) {\n return (constituencies.indexOf(\'|\' + constituency + \'|\') < 0);\n}"
       }
   }
}'

result = RestClient.put("#{DATABASE}/_design%2Fconstituencies", doc)

p result