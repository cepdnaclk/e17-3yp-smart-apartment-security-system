import express from "express";
import homePageController from "../controllers/homePageController";
import registerController from "../controllers/registerController";
import loginController from "../controllers/loginController";
import auth from "../validation/authValidation";
import passport from "passport";
import initPassportLocal from "../controllers/passportLocalController";
import apartments from "../controllers/apartments";
import security from "../controllers/securitycontrol";
import sensors from "../controllers/sensors";

// Init all passport
initPassportLocal();

let router = express.Router();

let initWebRoutes = (app) => {
    router.get("/", loginController.checkLoggedIn, homePageController.handleHelloWorld);
    router.get("/login",loginController.checkLoggedOut, loginController.getPageLogin);
    router.post("/login", passport.authenticate("local", {
        successRedirect: "/",
        failureRedirect: "/login",
        successFlash: true,
        failureFlash: true
    }));

    router.get("/edit/:userId", homePageController.edithomeusers);
    router.get("/delete/:userId", homePageController.deleteowner);
    router.get("/register", registerController.getPageRegister);
    router.post("/register", auth.validateRegister, registerController.createNewUser);
    router.post("/logout", loginController.postLogOut);
    router.post("/updateowners", homePageController.updateowners);
    router.get('/apartment', apartments.apartments);
    router.get('/addapartment', apartments.apartmentregister);
    router.post("/saveapartment", apartments.saveapartmentdetail);
    router.get('/security', security.security);
    router.get('/addofficer', security.securityregister);
    router.post("/saveofficer", security.savesecuritydetail);
    router.get('/sensors', sensors.sensors);
    router.get('/addsensor', sensors.sensorsregister);
    router.post("/savesensor", sensors.savesensorsdetail);

    router.get("/deleteapartment/:userId", apartments.deleteapartment);
    router.get("/deleteofficer/:userId", security.deleteofficer);
    router.get("/deletesensor/:userId", sensors.deletesensor);

    router.get("/editapartment/:userId", apartments.editapartment);
    router.get("/editofficer/:userId", security.editofficer);
    router.get("/editsensors/:userId", sensors.editsensors);

    router.post("/updateofficer", security.updateofficer);
    router.post("/updateapartment", apartments.updateapartment);
    router.post("/updatesensors", sensors.updatesensors);

    return app.use("/", router);
};
module.exports = initWebRoutes;
