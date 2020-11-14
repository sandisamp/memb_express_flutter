const router = require('express').Router();
const User = require('../model/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const {registrationValidation, loginValidation} = require('../parse_data/Validation');



router.post('/register', async (req,res) => {

    const {error} = registrationValidation(req.body);
    if (error != null){
        //console.log(isValid);
        return res.status(400).send(error.details[0].message);
    }
    // check is email exist
    const emailExist = await User.findOne({email: req.body.email});
    if (emailExist){
        return res.status(400).send('Email already exists!');
    }

    // Hash passwords
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(req.body.password, salt);

    const user = new User({
        name: req.body.name,
        email: req.body.email,
        password: hashedPassword
    });
    try{
        const Saveduser = await user.save();
        res.send(Saveduser);
    }catch(err){
        res.status(400).send(err);
    }
});

router.post('/login', async (req,res) => {
    //validate
    const {error} = loginValidation(req.body);
    if (error != null){
        //console.log(isValid);
        return res.status(400).send(error.details[0].message);
    }

    //check if email exists
    const user = await User.findOne({email: req.body.email});
    if (!user){
        return res.status(400).send('Incorrect email or user not found!');
    }
    const validPass = await bcrypt.compare(req.body.password, user.password);
    if (!validPass){
        return res.status(400).send('Authentication failed. Check email or password!');
    }

    // create jsonwebtoken
    const token = jwt.sign({_id: user._id},process.env.TOKEN);
    res.header('auth-token', token).send({'token': token,'id': user._id});
    // res.send(user._id);
    // res.send('Logged in!');
});


module.exports = router;