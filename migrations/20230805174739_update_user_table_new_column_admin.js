exports.up = function(knex) {
    return knex.schema.table('users', function(table) {
        table.boolean('admin').defaultTo(false);
    });
};

exports.down = function(knex) {
    return knex.schema.table('users', function(table) {
        table.dropColumn('admin');
    });
};
