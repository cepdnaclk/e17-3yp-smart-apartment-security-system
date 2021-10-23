import DBConnection from "./../configs/DBConnection";

let sensors = async (req, res) => {
    let sql = "SELECT * FROM sensor";
    let query = DBConnection.query(sql, (err, rows) => {
        if(err) throw err;
        res.render('sensors', {
            users : rows
        });
    });
};

let sensorsregister = (req, res) => {
    return res.render("newsensor", {
        errors: req.flash("errors")
    });
};

let savesensorsdetail = async (req, res) => { 
    let data = {id: req.body.id, uniqueid: req.body.uniqueid, type: req.body.type, mode: req.body.mode, status: req.body.status, email: req.body.email};
    let sql = "INSERT INTO sensor SET ?";
    let query = DBConnection.query(sql, data,(err, results) => {
      if(err) throw err;
      res.redirect('/sensors');
    });
};

let deletesensor = async (req, res) => {
    const userId = req.params.userId;
    let sql = `DELETE from sensor where id = ${userId}`;
    let query = DBConnection.query(sql,(err, result) => {
        if(err) throw err;
        res.redirect('/sensors');
    });
};

let updatesensors = async (req, res) => {
    const userId = req.body.id;
    let sql = "update sensor SET uniqueid='"+req.body.uniqueid+"',  type='"+req.body.type+"', mode='"+req.body.mode+"', email='"+req.body.email+"' where id ="+userId;
    let query = DBConnection.query(sql,(err, results) => {
      if(err) throw err;
      res.redirect('/sensors');
    });
};

let editsensors = async (req, res) => {
    const userId = req.params.userId;
    let sql = `Select * from sensor where id = ${userId}`;
    let query = DBConnection.query(sql,(err, result) => {
        if(err) throw err;
        res.render('sensor_edit', {
            user : result[0]
        });
    });
};      

module.exports = {
    sensors : sensors,
    sensorsregister : sensorsregister,
    savesensorsdetail : savesensorsdetail,
    deletesensor : deletesensor,
    updatesensors : updatesensors,
    editsensors : editsensors,

};
