exports.seed = function(knex) {
    const roles = [
        {id: 1, name: 'Owner'},
        {id: 2, name: 'Resident'},
        {id: 3, name: 'Guest'},
    ];

    // Используем Promise.all, чтобы обработать каждую роль отдельно
    return Promise.all(roles.map(role => {
        return knex('homeRole')
            .where('id', role.id)   // Проверка по ID
            .orWhere('name', role.name)  // или по имени
            .first()   // Получаем первую совпадающую запись
            .then(existingRole => {
                // Если запись не найдена, вставляем её
                if (!existingRole) {
                    return knex('homeRole').insert(role);
                }
            });
    }));
};
