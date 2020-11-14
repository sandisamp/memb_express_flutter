const fetch = require('node-fetch');

const baseurl = 'https://api.dictionaryapi.dev/api/v2/entries/';
const lang = 'en';

const parseVocab = async (data) => {
    try {
        const response = await fetch(baseurl + lang + '/' + data);
        const jsonData = await response.json();
        // console.log(jsonData);
        if (response.status !== 200){
            return false;
        }else{
            return jsonData;
        }
    } catch (error) {
        console.log(error);
        return error;
    }
};

module.exports.parseVocab = parseVocab;