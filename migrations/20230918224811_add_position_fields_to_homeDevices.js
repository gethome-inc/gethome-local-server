exports.up = function(knex) {
    return knex.schema.table('homeDevices', function(table) {
        table.integer('positionLeft').nullable();
        table.integer('positionTop').nullable();
    });
};

exports.down = function(knex) {
    return knex.schema.table('homeDevices', function(table) {
        table.dropColumn('positionLeft');
        table.dropColumn('positionTop');
    });
};
