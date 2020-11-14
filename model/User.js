const mongoose = require('mongoose');

const userScehma = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        min: 6,
        max: 255
    },
    email: {
        type: String,
        required: true,
        min: 6
    },
    password: {
        type: String,
        required: true,
        min: 6,
        max: 1024
    }
});

module.exports = mongoose.model('User',userScehma);