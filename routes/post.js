const router = require('express').Router();
const verify = require('./verifyToken');
const Vocab = require('../model/Vocab');
const {vocabValidation} = require('../parse_data/Validation');
const { parseVocab } = require('../parse_data/getVocabData');


router.post('/vocab', verify, async (req,res) => {
    
    // console.log(req.body);
    const {error} = vocabValidation(req.body);
    if (error != null){
        return res.status(400).send(error.details[0].message);
    }
    const metaData = await parseVocab(req.body.key);

    const vocab = new Vocab({
        owners: [ { userId: req.body.user }],
        key: req.body.key,
        meta: metaData
    });
    // return res.send(metaData);
    if (metaData === false){
        return res.status(404).send("Key not found!");
    }
    const vocabEntry = await Vocab.findOne({
        key: req.body.key
    });
    try{
        if (!vocabEntry){
            await vocab.save();
            // console.log('direct save') 
        }else{
            // console.log("trying to push to array")
            await Vocab.updateOne(
                { 'owners.userId': {$ne : req.body.user },
            key: req.body.key},
                {
                    $push: {
                    owners: {userId: req.body.user}
                }}
            );
        }
        return res.status(200).send(metaData);
    }catch(err){
        if (vocabEntry){
            res.status(200).send("This key already exists!");
        }
        else{
            res.status(400).send(err);
            console.log(err);
        }
    }
});

router.post('/reinforcement',verify , async (req,res) => {
    // const userId = req.body.user;
    // const key = req.body.key; // could be array
    
    let existingConf = await Vocab.findOne({
        'owners.userId': {$eq : req.body.user},
        'key': { $eq: req.body.key}
    }, {meta:0,key:0,_id:0,owners:{ $elemMatch: {userId: req.body.user}}});

    let updateCount = existingConf['owners'][0]['updateCount'] + 1;
    let curVal = existingConf['owners'][0]['memConf'];
    if ( req.body.remConf ){
        curVal = curVal + (( 1 - curVal )/16);
    }else{
        curVal = curVal - ((curVal)/2);
    }
    try{
        await Vocab.updateOne({'key': req.body.key, 'owners.userId': req.body.user},
        {
        'owners.$.updateCount': updateCount,
        'owners.$.memConf': curVal
        });
    }catch(err){
        console.log(err);
        res.send(err).status(400);
    }
    // console.log(existingConf);
    res.send(existingConf['owners'][0]).status(200);
});


module.exports = router;