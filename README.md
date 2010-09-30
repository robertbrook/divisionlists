# Division Lists

An example of marking up division lists using Sinatra and CouchDB.


## Files

* report.xml - the original provided demo file
* example.html - an example of the same content in HTML 5
* default.css - CSS file to make example.html a bit cleaner


## Setting Up

To get this to work, you're going to need CouchDB, couchdb-lucene and couchapp. If you already have those, feel free to skip past the instally stuff

### Installing stuff

#### CouchDB

If you're on a Mac, [CouchDBX](http://www.couchio.com/get#mac "CouchDBX") is your best bet (or if you really must tinker, [try this at your own risk](http://lizconlan.github.com/sandbox/couchdb-on-macosx.html)); otherwise the nice folk over at [CouchOne](http://www.couchio.com/get) should have something for you

#### CouchApp

CouchApp is a great way to package up the inner workings of your CouchDB - views, fulltext indexes, that sort of thing - without pushing individual documents around by hand. [Follow the installation instructions in the official README file](http://github.com/couchapp/couchapp/blob/master/README.md)

#### couchdb-lucene

The search engine bit. Reasonably painful to set up, but worth the effort.

1. Install Maven 2 if you don't already have it (good new fellow Mac-heads, nothing to do here). [Everyone else you need to go over here](http://maven.apache.org/download.html)
2. Grab the couchdb-lucene code from the [github repository](http://github.com/rnewson/couchdb-lucene) (hit the download source button over in the top right)
3. Unpack the couchdb-lucene code, open up a Terminal/iTerm/Command prompt window and navigate to the right directory
4. Type <code>mvn</code>
5. Make some tea
6. Navigate to the <code>target</code> subfolder and unpack the zip file you find in there
7. Rename the resulting folder <code>couchdb-lucene</code> and move it to where you want your couchdb-lucene app to live (I've put mine in <code>/usr/local</code>)
8. Locate your CouchDB <code>local.ini</code> file 
(if you're using CouchDBX you need to right-click on CouchDBX in your Applications folder and select "Show Package Contents", from there it's in Contents / Resources / couchdbx-core / couchdb_VERSION / etc / couchdb)
9. Hack in the following:
    <pre><code>
    [external]
    fti=/path/to/python /path/to/couchdb-lucene/tools/couchdb-external-hook.py
        
    [httpd_db_handlers]
    _fti = {couch_httpd_external, handle_external_req, <<"fti">>}
    </pre></code>
10. Under [couchdb] change os_process_timeout as follows:
     <pre><code>os_process_timeout=60000 ; increase the timeout from 5 seconds.</code></pre>
11. Restart CouchDB

### Setting up the app

#### Setup the database

1. Start CouchDB (if it isn't already running)
2. Grab a Terminal window and navigate to the db folder
3. Run <code>couchapp push http://localhost:5984/divisionlists
4. Run <code>rake load_data</code>

#### Start couchdb-lucene

1. In a new Terminal window, navigate to your couchdb-lucene folder
2. Run <code>bin/run</code>

## A few examples

The lucene search isn't properly hooked into the app (yet), but in the meantime you can test it out by running some queries over HTTP

<pre><code>
http://localhost:5984/divisionlists/_fti/_design/data/test?q=Roman

http://localhost:5984/divisionlists/_fti/_design/data/test?q=constituency:Essex

http://localhost:5984/divisionlists/_fti/_design/data/test?q=title:Lord

http://localhost:5984/divisionlists/_fti/_design/data/test?q=surname:Christie

http://localhost:5984/divisionlists/_fti/_design/data/test?q=forename:David

http://localhost:5984/divisionlists/_fti/_design/data/test?q=forename:%22Winston%20Spencer%22
</code></pre>