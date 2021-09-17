import DBConnection from "./../configs/DBConnection";

let handleHelloWorld = async (req, res) => {
    let sql = "SELECT * FROM houseowners";
    let query = DBConnection.query(sql, (err, rows) => {
        if(err) throw err;
        res.render('homepage', {
            users : rows
        });
    });
};

let edithomeusers = async (req, res) => {
    const userId = req.params.userId;
    let sql = `Select * from houseowners where id = ${userId}`;
    let query = DBConnection.query(sql,(err, result) => {
        if(err) throw err;
        res.render('user_edit', {
            user : result[0]
        });
    });
};

let updateowners = async (req, res) => {
    const userId = req.body.id;
    let sql = "update houseowners SET name='"+req.body.name+"',  email='"+req.body.email+"', houseid='"+req.body.houseid+"',  mobileno='"+req.body.mobileno+"' where id ="+userId;
    let query = DBConnection.query(sql,(err, results) => {
      if(err) throw err;
      res.redirect('/');
    });
};

let deleteowner = async (req, res) => {
    const userId = req.params.userId;
    let sql = `DELETE from houseowners where id = ${userId}`;
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
