#!/usr/bin/env node

var fs = require('fs');

if (fs.existsSync('./config.js')) {
  var config = require('./config.js')
} else { 
  console.log('No config.js file found: please edit config.default.js and save as config.js') 
  process.exit() 
}

var express = require('express'),
    bodyParser = require('body-parser'),
    mysql      = require('mysql')
 
require('body-parser-xml')(bodyParser)

var mysqlPoolConfig = Object.assign({timezone : 'z'},config.mysqlConfig)

var mysqlPool  = mysql.createPool(mysqlPoolConfig)

var dbWorkers = []

var app = express()
app.use(bodyParser.xml({
  limit: '1MB',   // Reject payload bigger than 1 MB 
  xmlParseOptions: {
    normalize: true,     // Trim whitespace inside text nodes 
    normalizeTags: false, // Transform tags to lowercase 
    explicitArray: false, // Only put nodes in array if >1 
    mergeAttrs: true
  }
}))
 
app.post('/cdr', function(req, res, body) {
  // Any request with an XML payload will be parsed 
  // and a JavaScript object produced on req.body 
  // corresponding to the request payload. 

  if ( req.body.records.record.length > 0 ) { 
    var myRecords = req.body.records.record
  } else {
    var myRecords = [ req.body.records.record ]
  }
  console.log('session: ' + req.body.records.session)
  for ( var i = 0; i < myRecords.length; i++){
    console.log(myRecords[i])
    if ( typeof myRecords[i].numPreceedingRecordsMissing != 'undefined' ){
      console.log('Records missing: ' + myRecords[i].numPreceedingRecordsMissing)
      delete myRecords[i].numPreceedingRecordsMissing
    }
    myRecords[i].session = req.body.records.session
    var dbWorker = new RecordWriter(myRecords[i])
    dbWorkers.push(dbWorker)
    console.log('--------end record-----------')
    res.status(200).end()
  }
  console.log('--------end records---------')
})

app.listen(config.listenPort,  function () {
    console.log('cdrReceiver is listening on port: ',config.listenPort)
})

function RecordWriter(record){
  if ( record.type == 'callStart' ){
    var post = record.call
    post.start = record.time
    mysqlPool.query('INSERT INTO calls SET ?', post, function (error, results, fields) {
      if (error) console.log(error)
      console.log('inserted call')
      post = record
      tmp = record.call.id
      post.call = tmp
      mysqlPool.query('INSERT INTO callEvents SET ?', post, function (error, results, fields) {
        if (error) console.log(error)
        console.log('inserted callEvent')
      })
    }.bind(this))
  } else if ( record.type == 'callEnd' ){
    var post = record.call
    id = mysqlPool.escape(post.id)
    post.end = record.time
    mysqlPool.query('UPDATE calls SET ? WHERE id = ' + id , post, function (error, results, fields) {
      if (error) console.log(error)
      console.log('updated call')
      post = record
      tmp = record.call.id
      post.call = tmp
      mysqlPool.query('INSERT INTO callEvents SET ?', post, function (error, results, fields) {
        if (error) console.log(error)
        console.log('inserted callEvent')
      })
    }.bind(this))
  } else if ( record.type == 'callLegStart' ){
    var post = record.callLeg
    post.start = record.time
    mysqlPool.query('INSERT INTO callLegs SET ?', post, function (error, results, fields) {
      if (error) console.log(error)
      console.log('inserted callLeg')
      post = record
      tmp = record.callLeg.id
      post.callLeg = tmp
      mysqlPool.query('INSERT INTO callLegEvents SET ?', post, function (error, results, fields) {
        if (error) console.log(error)
        console.log('inserted callLegEvent')
      })
    }.bind(this))
  } else if ( record.type == 'callLegUpdate' ){
    var post = record.callLeg
    id = mysqlPool.escape(post.id)
    if ( post.state == 'connected' ) post.connected = record.time
    mysqlPool.query('UPDATE callLegs SET ? WHERE id = ' + id , post, function (error, results, fields) {
      if (error) console.log(error)
      console.log('updated callLeg')
      post = record
      tmp = record.callLeg.id
      post.callLeg = tmp
      mysqlPool.query('INSERT INTO callLegEvents SET ?', post, function (error, results, fields) {
        if (error) console.log(error)
        console.log('inserted callLegEvent')
      })  
    }.bind(this))
  } else if ( record.type == 'callLegEnd' ){
    var post = record.callLeg
    id = mysqlPool.escape(post.id)
    post.end = record.time
    for (var j in post ){ if (typeof post[j] == "object") post[j] = JSON.stringify(post[j])}
    mysqlPool.query('UPDATE callLegs SET ? WHERE id = ' + id , post, function (error, results, fields) {
      if (error) console.log(error)
      console.log('updated callLeg')
      post = record
      tmp = record.callLeg.id
      post.callLeg = tmp
      mysqlPool.query('INSERT INTO callLegEvents SET ?', post, function (error, results, fields) {
        if (error) console.log(error)
        console.log('inserted callLegEvent')
      })
    }.bind(this))
  }


}
