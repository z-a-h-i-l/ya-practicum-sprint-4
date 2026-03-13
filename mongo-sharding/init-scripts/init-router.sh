# docker exec -it mongos_router mongosh --port 27020 --eval "
#   try { sh.addShard('shard1/shard1:27018'); } catch(e) { if(e.codeName !== 'ShardAlreadyExist') throw e; }
#   try { sh.addShard('shard2/shard2:27019'); } catch(e) { if(e.codeName !== 'ShardAlreadyExist') throw e; }
#   try { sh.enableSharding('somedb'); } catch(e) { if(e.codeName !== 'DatabaseAlreadySharded') throw e; }
#   sh.shardCollection('somedb.helloDoc', { name: 'hashed' })
# "

# docker exec mongos_router mongosh --port 27020 --eval "sh.status()"

# Настройка кластера
mongosh --host mongos_router:27020 --eval "
  // Добавление шарда 1
  try {
    sh.addShard('shard1/shard1:27018');
    print('✅ shard1 добавлен в кластер');
  } catch(e) {
    if (e.codeName === 'ShardAlreadyExist') {
      print('ℹ shard1 уже в кластере');
    } else {
      print('❌ Ошибка добавления shard1: ' + e.message);
      throw e;
    }
  }

  // Добавление шарда 2
  try {
    sh.addShard('shard2/shard2:27019');
    print('✅ shard2 добавлен в кластер');
  } catch(e) {
    if (e.codeName === 'ShardAlreadyExist') {
      print('ℹ shard2 уже в кластере');
    } else {
      print('❌ Ошибка добавления shard2: ' + e.message);
      throw e;
    }
  }

  // Включение шардирования для БД
  try {
    sh.enableSharding('somedb');
    print('✅ Шардирование включено для somedb');
  } catch(e) {
    if (e.codeName === 'DatabaseAlreadySharded') {
      print('ℹ somedb уже шардирована');
    } else {
      print('❌ Ошибка enableSharding: ' + e.message);
      throw e;
    }
  }

  // Шардирование коллекции (идемпотентность проверяется внутри)
  try {
    sh.shardCollection('somedb.helloDoc', { name: 'hashed' });
    print('✅ Коллекция helloDoc шардирована');
  } catch(e) {
    if (e.codeName === 'NamespaceAlreadySharded') {
      print('ℹ helloDoc уже шардирована');
    } else {
      print('❌ Ошибка shardCollection: ' + e.message);
      throw e;
    }
  }

  print('\\n🎉 Настройка кластера завершена!');
"
mongosh --host mongos_router:27020 --eval "sh.status()"