exports.up = function(knex) {
    return knex.schema.createTable('homeRooms', table => {
        table.increments('id').primary();
        table.string('roomName').notNullable();
        table.integer('floorId').defaultTo(null);
        table.integer('order').defaultTo(null);
        table.timestamps(true, true);
    });
};

exports.down = function(knex) {
    return knex.schema.dropTable('homeRooms');
};
