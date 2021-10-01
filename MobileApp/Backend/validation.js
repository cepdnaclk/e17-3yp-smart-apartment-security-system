const Joi = require('joi');

const registrationSchema = Joi.object({
    name: Joi.string()
        .alphanum()
        .min(3)
        .max(30)
        .required(),

    email: Joi.string()
        .email(),

    phone: Joi.string()
        .alphanum()
        .min(10)
        .max(13)
        .required(),

    password: Joi.string()
        .pattern(new RegExp('^[a-zA-Z0-9]{3,30}$')),

    confirmpassword: Joi.ref('password'),
/*
    access_token: [
        Joi.string(),
        Joi.number()
    ],
*/
    houseid: Joi.number()
        .integer()
        .min(1900)
        .max(2013)

    
})
 //   .with('username', 'birth_year')
  //  .xor('password', 'access_token')
    //.with('password', '');

module.exports = {registrationSchema};
//schema.validate({ username: 'abc', birth_year: 1994 });
// -> { value: { username: 'abc', birth_year: 1994 } }

//schema.validate({});
// -> { value: {}, error: '"username" is required' }

// Also -
/*
try {
    const value = await schema.validateAsync({ username: 'abc', birth_year: 1994 });
}
catch (err) { }*/