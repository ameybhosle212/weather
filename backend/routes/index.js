const routes = require('express').Router()
const axios = require('axios')

routes.post("/getLatLong",async(req,res)=>{
    const {latitude , longitude } = req.body;
    console.log(req.body);
    if(latitude && longitude){
        const API_KEY = process.env.API_KEY
        console.log(API_KEY);
        var {data} = await axios.get(`http://api.openweathermap.org/data/2.5/weather?lat=${parseFloat(latitude)}&lon=${parseFloat(longitude)}&appid=${API_KEY}`)
        return res.json({'data':data})
    }else{
        return res.json({'Data':'Error Ocuured','status':'ok','error':'Latitue Or Longitude Not Found'})
    }
})

routes.post("/getPlace",async(req,res)=>{
    const {place} = req.body;
    console.log(place);
    if(place){
        const API_KEY = process.env.API_KEY
        console.log(API_KEY);
        var {data} = await axios.get(`https://api.openweathermap.org/data/2.5/weather?q=${place}&appid=${API_KEY}`)
        return res.json({'data':data})
    }else{
        return res.json({'data':'Error Ocuured','status':'ok','error':'Latitue Or Longitude Not Found'})
    }
})

module.exports = routes;