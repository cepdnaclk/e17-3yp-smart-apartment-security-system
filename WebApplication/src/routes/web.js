import express from "express";
import homePageController from "../controllers/homePageController";
import registerController from "../controllers/registerController";
import loginController from "../controllers/loginController";
import auth from "../validation/authValidation";
import passport from "passport";
import initPassportLocal from "../controllers/passportLocalController";
import apartments from "../controllers/apartments";

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

    return app.use("/", router);
};
module.exports = initWebRoutes;
