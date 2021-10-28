const DBConnection = require("./../configs/DBConnection");

let handleHelloWorld = async (req, res) => {
    let sql = "SELECT * FROM user4";
    let query = DBConnection.query(sql, (err, rows) => {
        if(err) throw err;
        res.render('homepage', {
            users : rows
        });
    });
};

let edithomeusers = async (req, res) => {
    const userId = req.params.userId;
    let sql = `Select * from user4 where houseid = "${userId}"`;
    let query = DBConnection.query(sql,(err, result) => {
        if(err) throw err;
        res.render('user_edit', {
            user : result[0]
        });
    });
};

let updateowners = async (req, res) => {
    const userId = req.body.id;
    let sql = "update user4 SET name='"+req.body.name+"',  email='"+req.body.email+"', houseid='"+req.body.houseid+"',  mobileno='"+req.body.mobileno+"' where id ="+userId;
    let query = DBConnection.query(sql,(err, results) => {
      if(err) throw err;
      res.redirect('/');
    });
};

let deleteowner = async (req, res) => {
    const userId = req.params.userId;
    let sql = `DELETE from user4 where houseid = "${userId}"`;
    let query = DBConnection.query(sql,(err, result) => {
        if(err) throw err;
        res.redirect('/');
    });
};

module.exports = {
    handleHelloWorld: handleHelloWorld,
    edithomeusers : edithomeusers,
    updateowners : updateowners,
    deleteowner : deleteowner,
};
