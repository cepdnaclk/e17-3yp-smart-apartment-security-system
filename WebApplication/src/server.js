//require('dotenv').config();
import express from "express";
import configViewEngine from "./configs/viewEngine";
import initWebRoutes from "./routes/web";
import bodyParser from "body-parser";
import cookieParser from 'cookie-parser';
import session from "express-session";
import connectFlash from "connect-flash";
import passport from "passport";
const path = require('path');

const https =require('https');
const fs = require('fs');

let app = express();

//load assets
app.use('/css', express.static(path.resolve(__dirname, "public/css")))

//use cookie parser
app.use(cookieParser('secret'));

//config session
app.use(session({
    secret: 'secret',
    resave: true,
    saveUninitialized: false,
    cookie: {
        maxAge: 1000 * 60 * 60 * 24 // 86400000 1 day
    }
}));


// Enable body parser post data
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

//Config view engine
configViewEngine(app);

//Enable flash message
app.use(connectFlash());


//Config passport middleware
app.use(passport.initialize());
app.use(passport.session());

// init all web routes
initWebRoutes(app);

let port = process.env.PORT || 3000;
//app.listen(port, () => console.log(`Building a login system with NodeJS is running on port ${port}!`));


const sslServer = https.createServer({
    key: fs.readFileSync(path.join(__dirname, 'cert', 'key.pem')),
    cert: fs.readFileSync(path.join(__dirname, 'cert', 'cert.pem')),
},app);


 sslServer.listen(port, () => console.log(`Secure server on 🔑 port ${port}!`));



//https://localhost:8081/apartment