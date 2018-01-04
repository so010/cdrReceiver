var config = module.exports = {}

// configuration for mysql database
config.mysqlConfig = { 
  connectionLimit : 10, // number of parralel connections to db 
  host : 'db-host.domain.tl', // data base host
  user : 'username', // data base user name
  password : 'this is not really a good password', // password
  database : 'db name', // data base name
}

config.listenPort = 8080 // port which CMS is sending its cdrs to 

