const { json } = require('express');
const express = require('express');
const router = express.Router();
var db = require('./db.js');


router.route('/register').post((req,res)=>{
    //get params
    var name = req.body.name;
    var email = req.body.email;
    var phone = req.body.phone;
    var password = req.body.password;
    var houseid = req.body.houseid;

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

router.route('/getdetails/:email').get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from user where email = '${id}'`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            if(data.length > 0)
            res.send(data[0]);
            else
            res.send(JSON.stringify({success:false,message:"Empty data"})); 
        }
    })
});

router.route('/updatemode/:email').post((req,res)=>{
    var id = req.params.email;
    var mode = req.body.mode;
    let sql = `UPDATE sensor SET mode='${mode}' WHERE email = '${id}'`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            res.send(JSON.stringify({success:true,message:'Successful'}));
        }
    })
});

router.route('/getsensordetails/:email').get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from sensor where email = '${id}' and type = "window"`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            if(data.length > 0)
            res.send(data[0]);
            else
            res.send(JSON.stringify({success:false,message:"Empty data"})); 
        }
    })
});


router.route('/getmotionsensordetails/:email').get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from sensor where email = '${id}' and type = "motion"`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            if(data.length > 0)
            res.send(data[0]);
            else
            res.send(JSON.stringify({success:false,message:"Empty data"})); 
        }
    })
});

router.route('/getmessage/:id').post((req,res)=>{
    var id = req.params.id;
    let sql = `Select * from message where id = '${id}'`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            if(data.length > 0)
            res.send(JSON.stringify({status:true,msg:data[0].message}))
            else
                res.send(JSON.stringify({success:false,message:"Empty data"})); 
        }
    })
});

router.route('/updateuserdetails/:email').post((req,res)=>{
    var id = req.params.email;
    var name = req.body.name;
    var phone = req.body.phone;
    var houseid = req.body.houseid;
    let sql = `UPDATE user SET name='${name}', phone='${phone}',houseid='${houseid}' WHERE email = '${id}'`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            res.send(JSON.stringify({success:true,message:'Successful'}));
        }
    })
});


module.exports = router;

