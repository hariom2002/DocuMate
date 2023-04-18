const express = require('express');
const UserModel = require('../models/userModel');
const jwt = require('jsonwebtoken');
const { JWTKey, tokenKey } = require('../constants');
const authRouter = express.Router();


authRouter.post('/api/signup', async (req, res)=>{
try {
	console.log("print here");
	    const {name, email, profilePic} = req.body;
	    let user = await UserModel.findOne({email:email});
	    if(!user){
	        user = new UserModel({email:email, name:name, profilePhoto:profilePic});
	        user = await user.save();
	    }
	    const token = jwt.sign({id:user._id}, JWTKey)
		console.log(token);
	    res.json({...user._doc, token})
} catch (e) {
	console.log("This the error from authRouter.post /api/signup}");
    res.status(500).json({error: e.message});
}
});

authRouter.get('/', async(req, res)=>{
	try {
		console.log("came here on /");
		const token = req.header(tokenKey);
		const verfied = jwt.verify(token, JWTKey)
		console.log(token);
        if(!verfied)return res.status(401).json({msg:'Token verfication failed'})
		const userId = verfied.id;
		const user = await UserModel.findById(userId);
		console.log(user);
		if(!user){
			return res.status(401).json({msg:'user Not found'});
		}
		res.json({...user._doc, token});
	} catch (err) {
		console.log("here is the error in / \n");
		console.log(err.message);
		// return res.status(401).json({error:err.message});
	}
})

module.exports = authRouter;