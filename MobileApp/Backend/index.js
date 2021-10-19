const express = require('express');
var bodyParser = require('body-parser');
const https = require('https');
const path = require('path');
const fs = require('fs');

const app = express();
//var db = require('./db.js');
app.use(express.json());
app.use(bodyParser.urlencoded({extended:true}));
const  userRouter = require('./user');
app.use('/user', userRouter);

const sslServer = https.createServer({
    key : fs.readFileSync(path.join(__dirname, 'cert', 'key.pem')),
    cert : fs.readFileSync(path.join(__dirname, 'cert', 'cert.pem'))
},app)

sslServer.listen(3000, console.log('your server start on port 3000'));