const { json } = require('express');
const express = require('express');
const router = express.Router();
var db = require('./db.js');
const {registrationSchema}= require('./validation');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const config = require("./auth.config");
const checkAuth = require('./middleware/check-auth');

router.route('/register').post(async (req,res)=>{


    var sqlQuery0 = "SELECT email FROM user4 WHERE email=?";

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
            const {name,email,phone,password,houseid, apartmentid} = validatedResult.value;
            var enc = password
            const salt = await bcrypt.genSalt(8);
            enc = await bcrypt.hash(enc,salt);
        
            //create query
            var sqlQuery = "INSERT INTO user4(name,email,phone,password,houseid,apartmentid) VALUES (?,?,?,?,?,?)";
        
            //call database to insert so add or include database
            // pass params here
            db.query(sqlQuery, [name,email,phone,enc,houseid,apartmentid],function(error,data,fields){
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
                    const token= jwt.sign({
                        email : data[0].email

                    },
                    config.secret,
                    {
                        expiresIn: "1h"
                    });

                    res.send(JSON.stringify({success:true,user:data, token: token}));

                }else{
                    res.send(JSON.stringify({success:false,message:"Incorrect password"}));

                }
            }else{
                res.send(JSON.stringify({success:false,message:"Not a registered Email"})); 
            }
        }
    });  

});

router.route('/loginSO').post((req,res)=>{
    var email = req.body.email;
    var password = req.body.password;

    var sql = "SELECT * FROM securityofficer WHERE email=? AND password=?";

    db.query(sql, [email,password],async function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }
        else{
            if (data.length > 0){
                //res.send(JSON.stringify({success:true,user:data}));
                const validPassword = await bcrypt.compare(password, data[0].password);
                if(validPassword){
                    const token= jwt.sign({
                        email : data[0].email

                    },
                    config.secret,
                    {
                        expiresIn: "1h"
                    });

                    res.send(JSON.stringify({success:true,user:data, token: token}));

                }else{
                    res.send(JSON.stringify({success:false,message:"Incorrect password"}));

                }
            }else{
                res.send(JSON.stringify({success:false,message:"Not a registered Email"})); 
            }
        }
    });

}); 

router.route('/getdetails/:email',checkAuth).get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from user4 where email = '${id}'`;
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

router.route('/sogetdetails/:email',checkAuth).get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from securityofficer where email = '${id}'`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            if(data.length > 0)
            res.send(data);
            else
            res.send(JSON.stringify({success:false,message:"Empty data"})); 
        }
    })
});

router.route('/getallsensordetails/:email',checkAuth).get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from se where apartmentid = (SELECT apartmentid FROM securityofficer WHERE email = '${id}')`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            if(data.length > 0)
            res.send(data);
            else
            res.send(JSON.stringify({success:false,message:"Empty data"})); 
        }
    })
});

router.route('/getfpsensordetails/:email').get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from fingerprintsensor where houseid = (SELECT houseid FROM user4 WHERE email = '${id}')`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            if(data.length > 0)
            res.send(data);
            else
            res.send(JSON.stringify({success:false,message:"Empty data"})); 
        }
    })
});

router.route('/getso/:email',checkAuth).get((req,res)=>{
    var id = req.params.email;
    let sql = `Select phone from securityofficer where apartmentid = (SELECT apartmentid FROM user WHERE email = '${id}')`;
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

router.route('/getalluserdetails/:email',checkAuth).get((req,res)=>{
    var id = req.params.email;
    let sql = `Select name,phone,houseid from user4 where apartmentid = (SELECT apartmentid FROM securityofficer WHERE email = '${id}')`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            if(data.length > 0)
            res.send(data);
            else
            res.send(JSON.stringify({success:false,message:"Empty data"})); 
        }
    })
});

router.route('/updatemode/:email',checkAuth).post((req,res)=>{
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

router.route('/updatemodesensor/:email').post((req,res)=>{
    var id = req.params.email;
    var status = req.body.status;
    let sql = `UPDATE se SET status ='${status}' WHERE apartmentid = (SELECT apartmentid FROM user4 WHERE email = '${id}')`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            res.send(JSON.stringify({success:true,message:'Successful'}));
        }
    })
});

router.route('/updatesoaccess/:email').post((req,res)=>{
    var id = req.params.email;
    var status = req.body.status;
    let sql = `UPDATE soaccess SET soaccess ='${status}' WHERE houseid = (SELECT houseid FROM user4 WHERE email = '${id}')`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            res.send(JSON.stringify({success:true,message:'Successful'}));
        }
    })
});

router.route('/getsensordetails/:email',checkAuth).get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from se where type = "window sensor" and apartmentid = (SELECT apartmentid FROM user4 WHERE email = '${id}')`;
    //let sql = `Select * from sensor where email = '${id}' and type = "window"`;
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


router.route('/getmotionsensordetails/:email',checkAuth).get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from se where type = "motion sensor" and apartmentid = (SELECT apartmentid FROM user4 WHERE email = '${id}')`;
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

router.route('/getaccessfpsensordetails/:email').get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from soaccess where soaccess = 'true' and apartmentid = (SELECT apartmentid FROM securityofficer WHERE email = '${id}')`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            if(data.length > 0)
            res.send(data);
            else
            res.send(JSON.stringify({success:false,message:"Empty data"})); 
        }
    })
});

router.route('/getflamesensordetails/:email').get((req,res)=>{
    var id = req.params.email;
    let sql = `Select * from se where type = "flame sensor" and apartmentid = (SELECT apartmentid FROM user4 WHERE email = '${id}')`;
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


router.route('/getmessage/:id',checkAuth).post((req,res)=>{
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

router.route('/updateuserdetails/:email',checkAuth).post((req,res)=>{
    var id = req.params.email;
    var name = req.body.name;
    var phone = req.body.phone;
    var houseid = req.body.houseid;
    let sql = `UPDATE user4 SET name='${name}', phone='${phone}',houseid='${houseid}' WHERE email = '${id}'`;
    db.query(sql,function(err,data,fields){
        if(err){
            res.send(JSON.stringify({success:false,message:err}));
        }else{
            res.send(JSON.stringify({success:true,message:'Successful'}));
        }
    })
});


module.exports = router;

