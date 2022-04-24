const express = require('express');
const path = require('path');
const cors = require('cors')
const PORT = process.env.PORT || 5000;
const app = express();
const routes = require('./src/routes')
const bodyParser = require('body-parser');

app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json());




// app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.use('/api', routes);

app.listen(PORT, () => console.log(`Listening on ${PORT}`));