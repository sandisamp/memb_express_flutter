const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const app = express();


dotenv.config();

const authRoute = require('./routes/auth');
const postRoute = require('./routes/post');
const getRoute = require('./routes/get');
//Conenct to Db
mongoose.connect(process.env.DBCONNECT, 
{ useNewUrlParser: true ,
 useUnifiedTopology: true },
() => {console.log('Conencted to DB')});

//Middleware
app.use(express.json());

// Route middleware
app.use('/api/user', authRoute);
app.use('/api/post', postRoute);
app.use('/api/get', getRoute);
app.listen(3000, () => console.log('Up and running'));