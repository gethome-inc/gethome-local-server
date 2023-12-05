exports.up = function(knex) {
    return knex.schema.createTable('homeFloors', table => {
        table.increments('id').primary();
        table.string('floorName').notNullable();
        table.integer('homeId').notNullable();
        table.string('floorImage').defaultTo(null);
        table.integer('order').defaultTo(null);
        table.timestamps(true, true);
    });
};

exports.down = function(knex) {
    return knex.schema.dropTable('homeFloors');
};
