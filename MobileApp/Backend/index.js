const express = require('express');
const app = express();
var bodyParser = require('body-parser');

//var db = require('./db.js');
app.use(express.json());
app.use(bodyParser.urlencoded({extended:true}));
const  userRouter = require('./user');
app.use('/user', userRouter);

app.listen(3000, console.log('your server start on port 3000'));