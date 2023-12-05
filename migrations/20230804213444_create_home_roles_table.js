exports.up = function(knex) {
    return knex.schema.createTable('homeRole', function(table) {
        table.increments();
        table.string('name').notNullable().unique();
    });
};

exports.down = function(knex) {
    return knex.schema.dropTable('homeRole');
};
