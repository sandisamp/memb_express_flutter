const { array } = require('joi');
const mongoose = require('mongoose');
const user = require('./User');

const vocabSchema = mongoose.Schema({
    owners:[ 
            {
                userId: {type : mongoose.Schema.Types.ObjectId , ref: user, required: true},
                memConf: {type: mongoose.Schema.Types.Number , default: '0.2' },
                updateCount: {type: mongoose.Schema.Types.Number, default: '1', required: true}
            }
    ],
    key:{
        type: String,
        min: 1,
        max: 255,
        required: true
    },
    meta:{
        type: JSON,
        min: 1,
        required: true
    }
});

module.exports = mongoose.model('Vocab',vocabSchema);