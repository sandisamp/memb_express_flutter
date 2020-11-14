const { verify } = require('jsonwebtoken');
const Mongoose = require('mongoose');
const Vocab = require('../model/Vocab');

const router = require('express').Router();

router.get('/vocabData/:key', verify, async (req,res) => {
    if (req.params.key){
        const vocabEntry = await Vocab.findOne({key: req.params.key});
        res.send(vocabEntry).status(200);
    }else{
        res.status(400);
    }
});

router.get('/resources/:userId', verify, async (req,res) => {
    if (req.params.userId){
        const userResourceData = await Vocab.find(
            {            
            'owners.memConf' : { $lte : 0.9 },
            owners: {
                $all:{
                    $elemMatch: {userId: Mongoose.Types.ObjectId(req.params.userId)}
                }
            }
        },{owners:0,__v:0,_id:0});
        
        if( userResourceData ){
            res.send(userResourceData).status(200);
        }
        else{
            res.send("No records found!").status(200);
        }
    }
    else{
        res.status(400);
    }
});

module.exports = router;
