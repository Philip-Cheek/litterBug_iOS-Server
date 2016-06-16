
var express = require('express');
var path = require('path');
var app = express();
var parseurl = require('parseurl');
console.log("got here")

var server = require('http').createServer(app);  
var bodyParser = require('body-parser');

app.use(bodyParser.json());

require('./server/config/mongoose.js');
require('./server/config/routes.js')(app);

var server = app.listen(5000, function(){
  console.log('we\'re on port 5000');
});

var io = require('./server/config/socketListener.js')(server);
