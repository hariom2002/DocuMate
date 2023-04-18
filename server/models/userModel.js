const mongoose = require('mongoose')

const userSchema = mongoose.Schema({
    name:{
        required:true,
        type:String
    },
    email:{
        type:String,
        required:true
    },
    profilePhoto:{
        type:String,
        required:true
    }
})

const UserModel = mongoose.model('userSchema', userSchema);

module.exports = UserModel;