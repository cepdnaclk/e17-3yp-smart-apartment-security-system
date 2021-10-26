const DBConnection = require("./../configs/DBConnection");


exports.index = function(req, res){
    var message = '';
   if(req.method == "POST"){
      var post  = req.body;
      var name= post.HouseID;
 
	  if (!req.files)
				return res.status(400).send('No files were uploaded.');
 
		var file = req.files.uploaded_image;
		var img_name=file.name;
 
	  	 if(file.mimetype == "image/jpeg" ||file.mimetype == "image/png"||file.mimetype == "image/gif" ){
                                 
              file.mv('src/public/images/'+file.name, function(err) {
                             
	              if (err)
 
	                return res.status(500).send(err);
      					var sql = "INSERT INTO `layouts`(`houseid`,`image`) VALUES ('" + name + "','" + img_name + "')";
 
    						var query = DBConnection.query(sql, function(err, result) {
    							 res.redirect('layout');
    						});
					   });
          } else {
            message = "This format is not allowed , please upload file with '.png','.gif','.jpg'";
            res.render('layout.ejs',{message: message});
          }
   } else {
      res.render('layout');
   }
 
};

exports.profile = function(req, res){
	var message = '';
	var id = req.params.id;
    var sql = `SELECT * FROM layouts WHERE houseid = (SELECT houseid FROM user4 WHERE email = '${id}')`;
    DBConnection.query(sql, function(err, result){
	  if(result.length <= 0)
	  message = "Profile not found!";
     
      res.send(result[0].image);
      //res.render('profile.ejs',{data:result, message: message});
      //console.log(result);
   });
};