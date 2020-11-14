const Joi = require('joi');
const joiObjectId = require('joi-objectid');

const validateObjectid = joiObjectId(Joi);
//Validation
const registrationValidation = (data) => {
    const validationSchema = Joi.object({
        name: Joi.string().min(6).required(),
        email: Joi.string().min(6).required().email(),
        password: Joi.string().min(6).required()
    });
    return validationSchema.validate(data);
}

const loginValidation = (data) => {
    const validationSchema = Joi.object({
        email: Joi.string().min(6).required().email(),
        password: Joi.string().min(6).required()
    });
    return validationSchema.validate(data);
}

const vocabValidation = (data) => {
    const validationSchema = Joi.object({
        user: validateObjectid().required(),
        key: Joi.string().min(1).max(255).required(),
        meta: Joi.object()
    })
    return validationSchema.validate(data);
}

module.exports.loginValidation = loginValidation;
module.exports.registrationValidation = registrationValidation;
module.exports.vocabValidation = vocabValidation;

