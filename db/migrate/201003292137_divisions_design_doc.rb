require 'db_helper'
require 'rubygems'
require 'rest_client'

doc = '{
   "_id": "_design/divisions",
   "language": "javascript",
   "views": {
       "by_year_month_day": {
           "map": "function(division) {\n  emit(division.numeric_date, division);\n}"
       },
       "by_number": {
           "map": "function(division) {\n  emit(division.number.replace(/Numb(,|\\.)/, \"\").replace(/,|\\./,\"\").replace(\" \", \"\"), division);\n}"
       }
   }
}'

result = RestClient.put("#{DATABASE}/_design%2Fdivisions", doc)

p result