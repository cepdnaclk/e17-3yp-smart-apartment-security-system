const{Router}= require('express');
const router =Router();

const mysqlConnection = require('../database/database');

router.get('/',(req,res)=>{
    res.status(200).json('Server on port 8000 and database is connected');
});

router.get('/:owner',(req,res)=>{
    mysqlConnection.query('select * from owner;',(error,rows,fields) => {
        if(!error){
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

router.get('/:owner/:id',(req,res)=>{
    const {id}=req.params;
    mysqlConnection.query('select * from owner where owner_id=?;',[id],(error,rows,fields) => {
        if(!error){
            res.json(rows);
        } else {
            console.log(error);
        }
    });
});

router.post('/owner',(req,res)=>{
    const {owner_id,house_id,f_name,l_name,email,passsward,tel_no}=req.body;
    console.log.apply(req.body);
    mysqlConnection.query('insert into owner(owner_id,house_id,f_name,l_name,email,passsward,tel_no) values(?,?,?,?,?,?,?);',
    [owner_id,house_id,f_name,l_name,email,passsward,tel_no],(error,rows,fields)=>{
        if(!error){
            res.json({Statos:'User saved'});
        } else {
            console.log(error);
        }        
    });
});

module.exports=router;