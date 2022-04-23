require('dotenv').config();

const { Pool } = require('pg');

let pool;

// if on heroku
if (process.env.ENVIRONMENT !== 'LOCAL') {
  pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false,
    },
  });
} else {
  // if on local
  pool = new Pool({
    user: process.env.USERNAME,
    password: process.env.PASSWORD,
    port: process.env.PORT,
    host: process.env.HOST,
    database: process.env.DATABASE_NAME,
    ssl: false,
  });
}

module.exports = {
  query: (text, params, callback) => {
    return pool.query(text, params, callback);
  },
};
