const express = require('express');
const app = new express();
const path = require("path");
const bodyParser = require("body-parser");

const port = 3000;

var Web3 = require('web3');
var web3 = new Web3();
//web3.setProvider(new web3.providers.HttpProvider("https://ropsten.infura.io/v3/384d268dccec44c596723daaeb87c9b6"));
web3.setProvider(new web3.providers.HttpProvider("http://localhost:7545"));

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.get('/',function(req,res){
    res.sendFile(path.join(__dirname+'/index.html'));
});

app.post('/', function(req,res){
    var account = req.body.direccion;
    console.log(account);
    
    web3.eth.getBalance(account, function(error, result){
        if(!error){
            console.log(JSON.stringify(result));
            res.send(`Puntos de la dirección: ${result}`);
        }else{
            console.error(error);
    }
     })


});

app.listen(port);
console.log(`Running at Port ${port}`);
//console.log(web3.eth.accounts);






