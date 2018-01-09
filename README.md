cdrReceiver
===========
nodejs application that receives cdr data from Cisco Meeting Server and stores to mysql db

### Requirements

- a server with installed OS ( Debian if you are in doubt )
- a mysql server somewhere
- a Cisco Meeting Server
- working network connection to/from mysql-server and CMS

### Install
- Clone repository: `git clone github.com:so010/cdrReceiver.git`
- Install nodejs (standard distribution repository is usually outdated or broken instead use something like [nodesource](https://nodejs.org/en/download/package-manager) )  
- Change to cloned repository `cd cdrReceiver`
- Install npm depencies: `npm install` 
- Edit cdrReceiver.service file and check PATHs if not cloned to /usr/local/src
- Copy cdrReceiver.service file to /etc/systemd/system and reload systemd: `systemctl daemon-reload`
- edit config.default.js (cdr Listening Port and  mysql access) and save as config.js
- Start the service: `systemctl start cdrReceiver`
- If cdrReceiver should start at boot: `systemctl enable cdrReceiver`


  
