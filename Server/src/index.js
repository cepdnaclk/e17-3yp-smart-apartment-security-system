const express = require('express');
const app=express();

//settings
app.set('port',process.env.PORT || 8000);

//Middlewares
app.use(express.json());

//routes
app.use(require('./routes/user'));

//start server

app.listen(app.get('port'),()=>{
    console.log('Server on port',app.get('port'));
});