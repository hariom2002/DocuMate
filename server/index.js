const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const http = require("http");
const authRouter = require("./routes/user");
const documentRouter = require("./routes/document");

const PORT = process.env.PORT | 3001;

const app = express();
var server = http.createServer(app);
var {Server} = require("socket.io");
const documentModel = require("./models/document_model");
const io = new Server(server);


app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

const DB = "mongodb+srv://Amanpatel:amanpatel@cluster0.ktstebb.mongodb.net/?retryWrites=true&w=majority";


mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection successful!");
  })
  .catch((err) => {
    console.log(err);
  });



io.on('connection', (socket)=>{
  socket.on('join', (documentId)=>{
    console.log("came here to socket connection");
    socket.join(documentId);
  });

  socket.on('typing',(data)=>{
    socket.broadcast.to(data.room).emit('changes', data);
  });

  socket.on('save', (data)=>{
    saveData(data);
  })
});

const saveData = async (data) => {
  let document = await documentModel.findById(data.room);
  document.content = data.delta;
  document = await document.save();
};

server.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});
