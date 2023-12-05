exports.up = function(knex) {
    return knex.schema.alterTable('homeDevices', table => {
        table.string('owner').nullable().defaultTo('owen');
        table.string('zigbeeName').nullable();

        table.unique(['homeId', 'zigbeeName']);
    });
};

exports.down = function(knex) {
    return knex.schema.alterTable('homeDevices', table => {
        table.dropUnique(['homeId', 'zigbeeName']);

        table.dropColumn('owner');
        table.dropColumn('zigbeeName');
    });
};
