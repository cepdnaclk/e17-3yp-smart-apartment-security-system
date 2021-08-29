let apartments = async (req, res) => {
    return res.render("apartments.ejs",{
        user: req.user
    });
};

module.exports = {
    apartments : apartments,
};
