import DBConnection from "./../configs/DBConnection";

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


module.exports = {
    apartments : apartments,
    apartmentregister : apartmentregister,
    saveapartmentdetail : saveapartmentdetail,
};
