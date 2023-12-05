exports.up = async (knex) => {
    await knex.schema.table('home', (table) => {
        table.boolean('mqttEnabled').defaultTo(true); // Add mqttEnabled field with default value true
    });
};

exports.down = async (knex) => {
    await knex.schema.table('home', (table) => {
        table.dropColumn('mqttEnabled');
    });
};
