exports.up = function(knex) {
    return knex.schema.createTable('home', function(table) {
        table.increments();
        table.string('name');
        table.string('mqtt_username').notNullable().unique();
        table.string('mqtt_password').notNullable();
        table.timestamps(true, true);
    });
};

exports.down = function(knex) {
    return knex.schema.dropTable('home');
};
