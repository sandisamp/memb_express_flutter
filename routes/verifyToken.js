const jwt = require('jsonwebtoken');

//middle route function to verify token
module.exports = function auth( req, res, next){
    const token = req.header('auth-token');
    if (!token){
        return res.status(401).send('Access denied');
    }
    try{
        const verified = jwt.verify(token, process.env.TOKEN);
        req.user = verified;
        next();
    }catch(err){
        res.send('Invalid token');
    }
}

