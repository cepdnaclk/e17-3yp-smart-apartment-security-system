const { json } = require('express');
const express = require('express');
const router = express.Router();
var db = require('./db.js');
const {registrationSchema}= require('./validation');


router.route('/register').post((req,res)=>{

    const validatedResult = registrationSchema.validate(req.body);

    if (validatedResult.error) {
        res.send(JSON.stringify({success:false,message:validatedResult.error}));  
    }
    
    //get params
    const {name,email,phone,password,houseid} = validatedResult.value;

    //create query
    var sqlQuery = "INSERT INTO user(name,email,phone,password,houseid) VALUES (?,?,?,?,?)";

    //call database to insert so add or include database
    // pass params here
    db.query(sqlQuery, [name,email,phone,password,houseid],function(error,data,fields){
        if(error){
            res.send(JSON.stringify({success:false,message:error}));
        }else{
            res.send(JSON.stringify({success:true,message:'register'}));
        }
    });
});

router.route('/login').post((req,res)=>{
    var email = req.body.email;
    var password = req.body.password;

    var sql = "SELECT * FROM user WHERE email=? AND password=?";

    db.query(sql, [email,password],function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            if(data.length > 0)
                res.send(JSON.stringify({success:true,user:data}));
            else
            res.send(JSON.stringify({success:false,message:"Empty data"})); 
        }
    });

});


module.exports = router;

