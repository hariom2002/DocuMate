// Docuement itself
// userID
// created at
// title 
// contents
const mongoose = require('mongoose');

const documentSchema = mongoose.Schema({
    uid:{
        required:true,
        type:String
    },
    createdAt:{
        type:Number,
        required:true,
    },
    title:{
        type:String,
        required:true,
        trim: true
    },
    content:{
        type:Array,
        default: []
    }
});


const documentModel = mongoose.model('Document', documentSchema);
module.exports = documentModel;
