require 'db_helper'
require 'rubygems'
require 'rest_client'

doc = '{
   "_id": "_design/index",
   "language": "javascript",
   "views": {
       "resolution": {
           "map": "function(doc) {\n  var words_used = \"|\";\n  var tokens;\n  if (doc.resolution) {\n    tokens = doc.resolution.split(/[^A-Z0-9\\-_]+/i);\n    for (word in tokens) {\n      keyword = tokens[word].toLowerCase();\n      if (words_used.indexOf(\"|\" + keyword + \"|\") < 0) {\n        if (keyword.length > 3) {\n          emit(keyword, doc._id);\n          words_used = words_used + keyword + \"|\";\n        }\n      }\n    }\n  }\n}"
       },
       "member_name": {
           "map": "function(doc) {\n  var words_used = \"|\";\n  var tokens;\n  if (doc.noes) {\n    for (voter in doc.noes) {\n      votename = doc.noes[voter].forename + \" \" + doc.noes[voter].surname;\n      tokens = votename.split(/[^A-Z0-9\\-_]+/i);\n      for (word in tokens) {\n        keyword = tokens[word].toLowerCase();\n        if (words_used.indexOf(\"|\" + keyword + \"|\") < 0) {\n          if (keyword.length > 1) {\n            emit(keyword, doc._id);\n            words_used = words_used + keyword + \"|\";\n          }\n        }\n      }\n    }\n  }\n  if (doc.ayes) {\n    for (voter in doc.ayes) {\n      votename = doc.ayes[voter].forename + \" \" + doc.ayes[voter].surname;\n      tokens = votename.split(/[^A-Z0-9\\-_]+/i);\n      for (word in tokens) {\n        keyword = tokens[word].toLowerCase();\n        if (words_used.indexOf(\"|\" + keyword + \"|\") < 0) {\n          if (keyword.length > 1) {\n            emit(keyword, doc._id);\n            words_used = words_used + keyword + \"|\";\n          }\n        }\n      }\n    }\n  }\n}"
       },
       "constituency": {
           "map": "function(doc) {\n  var words_used = \"|\";\n  var tokens;\n  if (doc.noes) {\n    for (voter in doc.noes) {\n      constituency = doc.noes[voter].constituency; \n      tokens = constituency.split(/[^A-Z0-9\\-_]+/i);\n      for (word in tokens) {\n        keyword = tokens[word].toLowerCase();\n        if (words_used.indexOf(\"|\" + keyword + \"|\") < 0) {\n          if (keyword.length > 1) {\n            emit(keyword, {\"id\": doc._id, \"number\":doc.number.replace(/Numb(,|\.)/, \"\").replace(/,|\./,\"\").replace(\" \", \"\")});\n            words_used = words_used + keyword + \"|\";\n          }\n        }\n      }\n      //emit the full constituency name\n      constituency = constituency.toLowerCase();\n      if (words_used.indexOf(\"|\" + constituency + \"|\") < 0) {\n        if (constituency != \"\" && constituency != \"???\") {\n          emit(constituency, {\"id\": doc._id, \"number\":doc.number.replace(/Numb(,|\.)/, \"\").replace(/,|\./,\"\").replace(\" \", \"\")});\n          words_used = words_used + constituency + \"|\";\n        }\n      }\n    }\n  }\n  if (doc.ayes) {\n    for (voter in doc.ayes) {\n      constituency = doc.ayes[voter].constituency;\n      tokens = constituency.split(/[^A-Z0-9\\-_]+/i);\n      for (word in tokens) {\n        keyword = tokens[word].toLowerCase();\n        if (words_used.indexOf(\"|\" + keyword + \"|\") < 0) {\n          if (keyword.length > 1) {\n            emit(keyword, {\"id\": doc._id, \"number\":doc.number.replace(/Numb(,|\.)/, \"\").replace(/,|\./,\"\").replace(\" \", \"\")});;\n            words_used = words_used + keyword + \"|\";\n          }\n        }\n      }\n      //emit the full constituency name\n      constituency = constituency.toLowerCase();\n      if (words_used.indexOf(\"|\" + constituency + \"|\") < 0) {\n        if (constituency != \"\" && constituency != \"???\") {\n          emit(constituency, {\"id\": doc._id, \"number\":doc.number.replace(/Numb(,|\.)/, \"\").replace(/,|\./,\"\").replace(\" \", \"\")});\n          words_used = words_used + constituency + \"|\";\n        }\n      }\n    }\n  }\n}"
       }
   }
}'

result = RestClient.put("#{DATABASE}/_design%2Findex", doc)

p result