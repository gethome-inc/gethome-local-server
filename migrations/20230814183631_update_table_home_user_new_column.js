exports.up = async (knex) => {
    await knex.schema.table('homeUser', (table) => {
        table.integer('personalId');
        table.unique(['userId', 'personalId']); // составной уникальный индекс для userId и personalId
    });
};

exports.down = async (knex) => {
    await knex.schema.table('homeUser', (table) => {
        table.dropUnique(['userId', 'personalId']); // удалить составной уникальный индекс
        table.dropColumn('personalId');
    });
};
