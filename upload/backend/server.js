const express = require('express');
const app = express();
const mongoose = require('mongoose');
const cors = require('cors');

var monngoURL = 'mongodb://db-service:27017/database'

app.use(cors({
    origin: '*'
}))


app.get('/api', (req, res) => {
	mongoose.connect(monngoURL, { useNewUrlParser: true })
	    .then(
		() => {
		    res.send({
			"data": "success mongo"
		    })
		}
	    ).catch((error) => {
		    res.send({
			"data": "fail mongo",
			"error":error
		    })
	    });
})




app.listen(5000, function() {
    console.log('listening on 5000')
});
