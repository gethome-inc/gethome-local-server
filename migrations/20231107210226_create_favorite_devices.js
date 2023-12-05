exports.up = function(knex) {
    return knex.schema.createTable('favoriteDevices', table => {
        table.increments('id').primary();
        table.integer('homeUserId').unsigned().notNullable().references('id').inTable('homeUser').onDelete('CASCADE');
        table.integer('deviceId').unsigned().notNullable().references('id').inTable('homeDevices').onDelete('CASCADE');
        table.unique(['homeUserId', 'deviceId']);
        table.timestamps();
    });
};

exports.down = function(knex) {
    return knex.schema.dropTable('favoriteDevices');
};
