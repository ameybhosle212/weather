const express = require('express')
const app = express()
const cors = require('cors')
require('dotenv').config()

app.use(express.json())
app.use(express.urlencoded({extended:true}))
app.use(cors())

app.use("/",require('./routes/index'))

app.listen(1001,()=>{
    console.log("SERVER AT 1001");
})