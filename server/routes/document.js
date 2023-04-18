const express = require('express');
const documentModel = require('../models/document_model');
const authMiddleware = require('../middlewares/auth_middleware');
const documentRouter = express.Router();

documentRouter.post('/doc/create' ,authMiddleware, async (req, res)=>{
    try {
        console.log("came on the document create ");
        const {createdAt} = req.body;
        let document = new documentModel({
            uid: req.userId,
            createdAt,
            title: 'untitled Document'
        });
        document = await document.save();
        res.json(document);
        console.log("left the document create");
    } catch (err) {
        console.log("this is the error message\n");
        console.log(err.message);
        res.status(501).json({error:err.message});
    }
});

documentRouter.get('/docs/me', authMiddleware, async(req, res)=>{
    try {
        console.log("came to the /docs/me");
        const  userId = req.userId;
        let documents = await documentModel.find({uid: userId});
        res.json(documents);
        console.log("leaving the /docs/me");
        
    } catch (error) {
        console.log("error from the api /docs/me \n");
        console.log(error.message);
        res.status(501).json({error:err.message});
    }
});

documentRouter.post("/doc/title", authMiddleware, async (req, res)=>{
    try {
        console.log("came to /doc/title/");
        const {id, title} = req.body;
        let document = await documentModel.findByIdAndUpdate(id, {title});
        res.json(document);
        console.log("leaving the /doc/title");
    } catch (error) {
        console.log("error from the /docs/title \n");
        console.log(error.message);
        res.status(501).json({error:err.message});
    }
});

documentRouter.get("/doc/:id", authMiddleware, async(req, res)=>{
    try {
        console.log("came to the /doc/:id");
        const id = req.params.id;
        let document = await documentModel.findById(id);
        res.json(document);
        console.log("leaving the /doc/:id");
    } catch (error) {
        console.log("error from the /docs/:id \n");
        console.log(error.message);
        res.status(501).json({error:err.message});
    }
});


module.exports = documentRouter;