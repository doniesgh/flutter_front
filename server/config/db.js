const mongoose = require('mongoose');
MONGO_URI="mongodb://127.0.0.1/TunisysMobile"
const connection  = mongoose.connect(MONGO_URI);

connection.then(()=>{
    console.log('Connected to MongoDB Tunisys');
}).catch((err)=>{
    console.log('Error: ', err);
});

module.export  = connection