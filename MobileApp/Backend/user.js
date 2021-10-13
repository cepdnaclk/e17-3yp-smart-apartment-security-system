const { json } = require('express');
const express = require('express');
const router = express.Router();
var db = require('./db.js');
const {registrationSchema}= require('./validation');
const bcrypt = require('bcrypt');

router.route('/register').post(async (req,res)=>{


    var sqlQuery0 = "SELECT email FROM user WHERE email=?";

    //call database to insert so add or include database
    // pass params here
    var validmail = true;
    db.query(sqlQuery0, [req.body.email],async function(error,data,fields){
    if (error) throw error;
        
    if (data.length > 0){
            validmail=false;
            res.send(JSON.stringify({success:false,message:'Email already exist!'}));
    }
    else{
            validmail=true;
            const validatedResult = registrationSchema.validate(req.body);

            if (validatedResult.error) {
                //console.log('%s',validatedResult.error.details[0].message);
               
                res.send(JSON.stringify({success:false,message:validatedResult.error.details[0].message}));  
                //console.log('%s',res['message']);
                
        
                return;
            }
            
            //get params
            const {name,email,phone,password,houseid} = validatedResult.value;
            var enc = password
            const salt = await bcrypt.genSalt(8);
            enc = await bcrypt.hash(enc,salt);
        
            //create query
            var sqlQuery = "INSERT INTO user(name,email,phone,password,houseid) VALUES (?,?,?,?,?)";
        
            //call database to insert so add or include database
            // pass params here
            db.query(sqlQuery, [name,email,phone,enc,houseid],function(error,data,fields){
                if(error){
                    res.send(JSON.stringify({success:false,message:error}));
                }else{
                    res.send(JSON.stringify({success:true,message:'register'}));
                }
            });
            
    }

    });



});

router.route('/login').post(async(req,res)=>{
    var email = req.body.email;
    var password = req.body.password;

    var sql = "SELECT * FROM user WHERE email=?";

    db.query(sql, [email],async function(err,data,fields){
        //console.log(data);
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }
        else{
            if (data.length > 0){
                //res.send(JSON.stringify({success:true,user:data}));
                const validPassword = await bcrypt.compare(password, data[0].password);
                if(validPassword){
                    res.send(JSON.stringify({success:true,user:data}));

                }else{
                    res.send(JSON.stringify({success:false,message:"Incorrect password"}));

                }
            }else{
                res.send(JSON.stringify({success:false,message:"Not a registered Email"})); 
            }
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

