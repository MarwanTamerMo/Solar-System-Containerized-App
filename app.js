const path = require('path');
const express = require('express');
const OS = require('os');
const bodyParser = require('body-parser');
const mongoose = require("mongoose");
const cors = require('cors');
const client = require('prom-client'); // Import prom-client

const app = express(); // Create a single app instance

// --- 1. SETUP PROMETHEUS METRICS ---
const register = new client.Registry();
register.setDefaultLabels({
    app: 'solar-system-app'
});
client.collectDefaultMetrics({ register });

// --- 2. SETUP MIDDLEWARE ---
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, '/')));
app.use(cors());

// --- 3. DATABASE CONNECTION ---
mongoose.connect(process.env.MONGO_URI, {
    user: process.env.MONGO_USERNAME,
    pass: process.env.MONGO_PASSWORD,
    useNewUrlParser: true,
    useUnifiedTopology: true
}, function (err) {
    if (err) {
        console.log("Database connection error!! " + err);
    } else {
        console.log("MongoDB Connection Successful");
    }
});

// --- 4. DATABASE SCHEMA AND MODEL ---
var Schema = mongoose.Schema;
var dataSchema = new Schema({
    name: String,
    id: Number,
    description: String,
    image: String,
    velocity: String,
    distance: String
});
var planetModel = mongoose.model('planets', dataSchema);


// --- 5. DEFINE ALL APP ROUTES ---

// ADD THE /metrics ENDPOINT FOR PROMETHEUS
app.get('/metrics', async (req, res) => {
    try {
        res.set('Content-Type', register.contentType);
        res.end(await register.metrics());
    } catch (ex) {
        res.status(500).end(ex);
    }
});

// Your existing application routes
app.post('/planet', function (req, res) {
    planetModel.findOne({
        id: req.body.id
    }, function (err, planetData) {
        if (err) {
            res.status(500).send("Error in Planet Data");
        } else {
            res.send(planetData);
        }
    });
});

app.get('/', async (req, res) => {
    res.sendFile(path.join(__dirname, '/', 'index.html'));
});

app.get('/os', function (req, res) {
    res.setHeader('Content-Type', 'application/json');
    res.send({
        "os": OS.hostname(),
        "env": process.env.NODE_ENV
    });
});

app.get('/live', function (req, res) {
    res.setHeader('Content-Type', 'application/json');
    res.send({
        "status": "live"
    });
});

app.get('/ready', function (req, res) {
    res.setHeader('Content-Type', 'application/json');
    res.send({
        "status": "ready"
    });
});

// --- 6. START THE SINGLE SERVER ---
app.listen(3000, () => {
    console.log("Server successfully running on port - " + 3000);
});

module.exports = app;