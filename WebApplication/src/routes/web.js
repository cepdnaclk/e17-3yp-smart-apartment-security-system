const express = require('express');
const homePageController = require("../controllers/homePageController");
const registerController = require("../controllers/registerController");
const loginController = require("../controllers/loginController");
const layoutController = require("../controllers/layouts");
const auth = require("../validation/authValidation");
const passport = require("passport");
const initPassportLocal = require("../controllers/passportLocalController");
const apartments = require("../controllers/apartments");
const security = require("../controllers/securitycontrol");
const sensors = require("../controllers/sensors");
const db = require("./../configs/DBConnection");
const {registrationSchema}= require('./validationformobile');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
//const config = require("./auth.config");
const checkAuth = require('./check-auth');

// Init all passport
initPassportLocal();

let router = express.Router();

let initWebRoutes = (app) => {
    router.get("/", loginController.checkLoggedIn, homePageController.handleHelloWorld);
    router.get("/login",loginController.checkLoggedOut, loginController.getPageLogin);
    router.post("/login", passport.authenticate("local", {
        successRedirect: "/",
        failureRedirect: "/login",
        successFlash: true,
        failureFlash: true
    }));

    router.route('/user/register').post(async (req,res)=>{

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

    router.route('/user/login').post(async(req,res)=>{
        var email = req.body.email;
        var password = req.body.password;
    
        var sql = "SELECT * FROM user4 WHERE email=?";
    
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
                        "secret",
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

    router.route('/user/loginSO').post((req,res)=>{
        var email = req.body.email;
        var password = req.body.password;
    
        var sql = "SELECT * FROM securityofficer WHERE email=? AND password=?";
    
        db.query(sql, [email,password],async function(err,data,fields){
            if(err){
                res.send(JSON.stringify({success:false,message:err}));
            }
            else{
                if (data.length > 0){
                    const token= jwt.sign({
                    email : data[0].email
                    //usertype : data[0].usertype
    
                },
                'secret',
                {
                    expiresIn: "1h"
                });
    
                res.send(JSON.stringify({success:true,user:data, token: token}));
                        
                }else{
                    res.send(JSON.stringify({success:false,message:"Not a registered Email"})); 
                }
                
            }
        });
    }); 

    
    router.route('/user/getdetails/:email').get(checkAuth,(req,res)=>{
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

    router.route('/user/getmodedetails/:email',checkAuth).get((req,res)=>{
        var id = req.params.email;
        let sql = `Select mode from sensors where houseid = (SELECT houseid FROM user4 WHERE email = '${id}')`;
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
    
    router.route('/user/sogetdetails/:email').get(checkAuth,(req,res)=>{
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
    
    router.route('/user/getallsensordetails/:email').get(checkAuth,(req,res)=>{
        var id = req.params.email;
        let sql = `Select * from sensors where apartmentid = (SELECT apartmentid FROM securityofficer WHERE email = '${id}')`;
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
    
    router.route('/user/getactivesensordetails/:email').get(checkAuth,(req,res)=>{
        var id = req.params.email;
        let sql = `Select * from sensors where status = 'active' and houseid = (SELECT houseid FROM user4 WHERE email = '${id}')`;
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
    
    router.route('/user/getfpsensordetails/:email').get(checkAuth,(req,res)=>{
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
    
    router.route('/user/getso/:email').get(checkAuth,(req,res)=>{
        var id = req.params.email;
        let sql = `Select phone from securityofficer where apartmentid = (SELECT apartmentid FROM user4 WHERE email = '${id}')`;
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
    
    router.route('/user/getalluserdetails/:email').get(checkAuth,(req,res)=>{
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
    
    router.route('/user/updatemode/:email').post(checkAuth,(req,res)=>{
        var id = req.params.email;
        var mode = req.body.mode;
        let sql = `UPDATE sensors SET mode='${mode}' WHERE houseid = (SELECT houseid FROM user4 WHERE email = '${id}')`;
        db.query(sql,function(err,data,fields){
            if(err){
                res.send(JSON.stringify({success:false,message:err}));
            }else{
                res.send(JSON.stringify({success:true,message:'Successful'}));
            }
        })
    });
    
    router.route('/user/updatemodesensor/:email').post(checkAuth,(req,res)=>{
        var id = req.params.email;
        var status = req.body.status;
        let sql = `UPDATE sensors SET status ='${status}' WHERE apartmentid = (SELECT apartmentid FROM user4 WHERE email = '${id}')`;
        db.query(sql,function(err,data,fields){
            if(err){
                res.send(JSON.stringify({success:false,message:err}));
            }else{
                res.send(JSON.stringify({success:true,message:'Successful'}));
            }
        })
    });
    
    router.route('/user/updatemodesensorstatus/:uniqueid').post(checkAuth,(req,res)=>{
        var id = req.params.uniqueid;
        var status = req.body.status;
        let sql = `UPDATE sensors SET status='${status}' WHERE uniqueid = '${id}'`;
        db.query(sql,function(err,data,fields){
            if(err){
                res.send(JSON.stringify({success:false,message:err}));
            }else{
                res.send(JSON.stringify({success:true,message:'Successful'}));
            }
        })
    });
    
    router.route('/user/updatesoaccess/:email').post(checkAuth,(req,res)=>{
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
    
    router.route('/user/getsensordetails/:email').get(checkAuth,(req,res)=>{
        var id = req.params.email;
        let sql = `Select * from sensors where type = "window sensor" and houseid = (SELECT houseid FROM user4 WHERE email = '${id}')`;//new
        //let sql = `Select * from sensor where email = '${id}' and type = "window"`;
        db.query(sql,function(err,data,fields){
            if(err){
                res.send(JSON.stringify({success:false,message:err}));
            }else{
                if(data.length > 0)
                res.send(data);//new
                else
                res.send(JSON.stringify({success:false,message:"Empty data"})); 
            }
        })
    });
    
    
    router.route('/user/getmotionsensordetails/:email').get(checkAuth,(req,res)=>{
        var id = req.params.email;
        let sql = `Select * from sensors where type = "motion sensor" and apartmentid = (SELECT apartmentid FROM user4 WHERE email = '${id}')`;
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
    
    router.route('/user/getaccessfpsensordetails/:email').get(checkAuth,(req,res)=>{
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
    
    router.route('/user/getflamesensordetails/:email').get(checkAuth,(req,res)=>{
        var id = req.params.email;
        let sql = `Select * from sensors where type = "flame sensor" and apartmentid = (SELECT apartmentid FROM user4 WHERE email = '${id}')`;
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
    
    
    router.route('/user/updateuserdetails/:email').post(checkAuth,(req,res)=>{
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



    router.get("/edit/:userId", homePageController.edithomeusers);
    router.get("/delete/:userId", homePageController.deleteowner);
    router.get("/register", registerController.getPageRegister);
    router.post("/register", auth.validateRegister, registerController.createNewUser);
    router.post("/logout", loginController.postLogOut);
    router.post("/updateowners", homePageController.updateowners);
    router.get('/apartment', apartments.apartments);
    router.get('/addapartment', apartments.apartmentregister);
    router.post("/saveapartment", apartments.saveapartmentdetail);
    router.get('/security', security.security);
    router.get('/addofficer', security.securityregister);
    router.post("/saveofficer", security.savesecuritydetail);
    router.get('/sensors', sensors.sensors);
    router.get('/addsensor', sensors.sensorsregister);
    router.post("/savesensor", sensors.savesensorsdetail);
    router.get("/layout", layoutController.index);
    router.post("/layout", layoutController.index);
    router.get("/layout/:id", layoutController.profile);

    router.get("/deleteapartment/:userId", apartments.deleteapartment);
    router.get("/deleteofficer/:userId", security.deleteofficer);
    router.get("/deletesensor/:userId", sensors.deletesensor);

    router.get("/editapartment/:userId", apartments.editapartment);
    router.get("/editofficer/:userId", security.editofficer);
    router.get("/editsensors/:userId", sensors.editsensors);

    router.post("/updateofficer", security.updateofficer);
    router.post("/updateapartment", apartments.updateapartment);
    router.post("/updatesensors", sensors.updatesensors);

    return app.use("/", router);
};
module.exports = initWebRoutes;
