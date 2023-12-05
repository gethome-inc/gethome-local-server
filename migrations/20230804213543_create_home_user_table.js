exports.up = function(knex) {
    return knex.schema.createTable('homeUser', function(table) {
        table.increments();
        table.integer('homeId').unsigned().notNullable();
        table.integer('userId').unsigned().notNullable();
        table.integer('roleId').unsigned().notNullable();

        table.foreign('homeId').references('home.id');
        table.foreign('userId').references('users.id');
        table.foreign('roleId').references('homeRole.id');

        table.unique(['userId', 'homeId']); // User can have only one role per home
    });
};

exports.down = function(knex) {
    return knex.schema.dropTable('homeUser');
};
