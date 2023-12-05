exports.up = function(knex) {
    return knex.schema.table('homeDevices', function(table) {
        table.integer('externalId').nullable();
    });
};

exports.down = function(knex) {
    return knex.schema.table('homeDevices', function(table) {
        table.dropColumn('externalId');
    });
};
