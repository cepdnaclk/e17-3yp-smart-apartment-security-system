import DBConnection from "./../configs/DBConnection";

let security = async (req, res) => {
    let sql = "SELECT * FROM securityofficer";
    let query = DBConnection.query(sql, (err, rows) => {
        if(err) throw err;
        res.render('security', {
            users : rows
        });
    });
};

let securityregister = (req, res) => {
    return res.render("newofficer", {
        errors: req.flash("errors")
    });
};

let savesecuritydetail = async (req, res) => { 
    let data = {name: req.body.name, apartmentid: req.body.ApartmentID, phone: req.body.MobileNo, email: req.body.email, password: req.body.password};
    let sql = "INSERT INTO securityofficer SET ?";
    let query = DBConnection.query(sql, data,(err, results) => {
      if(err) throw err;
      res.redirect('/security');
    });
};

let deleteofficer = async (req, res) => {
    const userId = req.params.userId;
    let sql = `DELETE from securityofficer where id = ${userId}`;
    let query = DBConnection.query(sql,(err, result) => {
        if(err) throw err;
        res.redirect('/security');
    });
};

let updateofficer = async (req, res) => {
    const userId = req.body.id;
    let sql = "update securityofficer SET name='"+req.body.name+"',  apartmentid='"+req.body.ApartmentID+"', phone='"+req.body.MobileNo+"', email='"+req.body.email+"' where id ="+userId;
    let query = DBConnection.query(sql,(err, results) => {
      if(err) throw err;
      res.redirect('/security');
    });
};

let editofficer = async (req, res) => {
    const userId = req.params.userId;
    let sql = `Select * from securityofficer where id = ${userId}`;
    let query = DBConnection.query(sql,(err, result) => {
        if(err) throw err;
        res.render('security_edit', {
            user : result[0]
        });
    });
};



module.exports = {
    security : security,
    securityregister : securityregister,
    savesecuritydetail : savesecuritydetail,
    deleteofficer : deleteofficer,
    updateofficer : updateofficer,
    editofficer : editofficer,
};
