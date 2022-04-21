const express = require('express');
const path = require('path');
const PORT = process.env.PORT || 5000;
const app = express();
const routes = require('./src/routes')
const bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json());

const { Pool } = require('pg');
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false,
  },
});

// app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
  res.send('Hello World');
});


app.use('/api', routes);

app.get('/db', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM blightsources');
    const results = { 'results': result ? result.rows : null };

    res.send(results);
    client.release();
  } catch (err) {
    console.error(err);
    res.send('Error ' + err);
  }
});

app.listen(PORT, () => console.log(`Listening on ${PORT}`));

module.exports = {
  query: (text, params, callback) => {
    return pool.query(text, params, callback)
  },
}