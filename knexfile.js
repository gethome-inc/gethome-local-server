require('dotenv').config({ path: './.env' });

module.exports = {
  development: {
    client: 'mysql',
    connection: {
      host: process.env.KNEX_HOST,
      port: process.env.DB_PORT,
      user: 'root',
      password: 'serverhome0001',
      database: 'gethome_server',
      charset: 'utf8mb4',
    },
    migrations: {
      directory: './migrations',
    },
  },
};
