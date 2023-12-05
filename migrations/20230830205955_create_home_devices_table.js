exports.up = function(knex) {
    return knex.schema.createTable('homeDevices', table => {
        table.increments('id').primary();
        table.string('deviceName').notNullable();
        table.integer('homeId').notNullable();
        table.integer('roomId').defaultTo(null);
        table.string('deviceType').defaultTo(null);
        table.integer('lineId').defaultTo(null);
        table.string('lineType').defaultTo(null);
        table.string('deviceStateText').defaultTo(null);
        table.boolean('deviceStateBool').defaultTo(null);
        table.integer('order').defaultTo(null);
        table.timestamps(true, true);
    });
};

exports.down = function(knex) {
    return knex.schema.dropTable('homeDevices');
};
