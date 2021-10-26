const DBConnection = require("./../configs/DBConnection");


let apartments = async (req, res) => {
    let sql = "SELECT * FROM apartments";
    let query = DBConnection.query(sql, (err, rows) => {
        if(err) throw err;
        res.render('apartments', {
            users : rows
        });
    });
};

let apartmentregister = (req, res) => {
    return res.render("newapartment", {
        errors: req.flash("errors")
    });
};

let saveapartmentdetail = async (req, res) => { 
    let data = {name: req.body.name, houseno: req.body.houseno, owner: req.body.owner, mobileno: req.body.mobileno, location: req.body.location};
    let sql = "INSERT INTO apartments SET ?";
    let query = DBConnection.query(sql, data,(err, results) => {
      if(err) throw err;
      res.redirect('/apartment');
    });
};


let deleteapartment = async (req, res) => {
    const userId = req.params.userId;
    let sql = `DELETE from apartments where id = ${userId}`;
    let query = DBConnection.query(sql,(err, result) => {
        if(err) throw err;
        res.redirect('/apartment');
    });
};

let updateapartment = async (req, res) => {
    const userId = req.body.id;
    let sql = "update apartments SET name='"+req.body.name+"',  houseno='"+req.body.houseno+"', owner='"+req.body.owner+"', location='"+req.body.location+"',  mobileno='"+req.body.mobileno+"' where id ="+userId;
    let query = DBConnection.query(sql,(err, results) => {
      if(err) throw err;
      res.redirect('/apartment');
    });
};

let editapartment = async (req, res) => {
    const userId = req.params.userId;
    let sql = `Select * from apartments where id = ${userId}`;
    let query = DBConnection.query(sql,(err, result) => {
        if(err) throw err;
        res.render('apartment_edit', {
            user : result[0]
        });
    });
};

module.exports = {
    apartments : apartments,
    apartmentregister : apartmentregister,
    saveapartmentdetail : saveapartmentdetail,
    deleteapartment : deleteapartment,
    updateapartment : updateapartment,
    editapartment : editapartment,
};
