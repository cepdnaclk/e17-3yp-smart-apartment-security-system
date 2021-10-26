const DBConnection = require("./../configs/DBConnection");


let sensors = async (req, res) => {
    let sql = "SELECT * FROM sensors";
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
    let data = {uniqueid: req.body.uniqueid, type: req.body.type, mode: req.body.mode, status: req.body.status, houseid: req.body.houseid, apartmentid: req.body.apartmentid};
    let sql = "INSERT INTO sensors SET ?";
    let query = DBConnection.query(sql, data,(err, results) => {
      if(err) throw err;
      res.redirect('/sensors');
    });
};

let deletesensor = async (req, res) => {
    const userId = req.params.userId;
    let sql = `DELETE from sensors where uniqueid = '${userId}'`;
    let query = DBConnection.query(sql,(err, result) => {
        if(err) throw err;
        res.redirect('/sensors');
    });
};

let updatesensors = async (req, res) => {
    const userId = req.body.uniqueid;
    let sql = "update sensors SET uniqueid='"+req.body.uniqueid+"',  type='"+req.body.type+"', mode='"+req.body.mode+"', houseid='"+req.body.houseid+"', apartmentid='"+req.body.apartmentid+"' where uniqueid ='"+userId+"'";
    let query = DBConnection.query(sql,(err, results) => {
      if(err) throw err;
      res.redirect('/sensors');
    });
};

let editsensors = async (req, res) => {
    const userId = req.params.userId;
    let sql = `Select * from sensors where uniqueid = '${userId}'`;
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
