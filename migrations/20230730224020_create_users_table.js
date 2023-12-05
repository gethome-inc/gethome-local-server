exports.up = function(knex) {
    return knex.schema.createTable('users', function(table){
        table.increments();
        table.string('phone').notNullable().unique();
        table.string('email');
        table.string('sms_verification_code');
        table.boolean('is_phone_verified').defaultTo(false);
        table.string('last_sms_sent');
        table.timestamps();
    });
};

exports.down = function(knex) {
    return knex.schema.dropTable('users');
};
