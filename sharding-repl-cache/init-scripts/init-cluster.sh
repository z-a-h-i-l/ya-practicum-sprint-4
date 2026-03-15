# Инициализация config_server
mongosh --host configSrv1:27017 --eval "
  try {
    rs.initiate({ _id: 'config_server', configsvr: true, members: [ 
        { _id: 0, host: 'configSrv1:27017', priority: 2 }, 
        { _id: 1, host: 'configSrv2:27017', priority: 1 }, 
        { _id: 2, host: 'configSrv3:27017', priority: 1 } ] });
    print('✅ config_server инициализирован');
  } catch(e) {
    if (e.codeName === 'AlreadyInitialized') {
      print('ℹ config_server уже инициализирован');
    } else {
      print('❌ Ошибка: ' + e.message);
      throw e;
    }
  }
"

# Ждём выбора PRIMARY
sleep 10

# Инициализация shard1
mongosh --host shard1a:27018 --eval "
  try {
    rs.initiate({ _id: 'shard1', members: [ 
        { _id: 0, host: 'shard1a:27018', priority: 2 }, 
        { _id: 1, host: 'shard1b:27018', priority: 1 },
        { _id: 2, host: 'shard1c:27018', priority: 1 } ] });
    print('✅ shard1 инициализирован');
  } catch(e) {
    if (e.codeName === 'AlreadyInitialized') {
      print('ℹ shard1 уже инициализирован');
    } else {
      print('❌ Ошибка: ' + e.message);
      throw e;
    }
  }
"

# Ждём выбора PRIMARY
sleep 10


# Инициализация shard2
mongosh --host shard2a:27019 --eval "
  try {
    rs.initiate({ _id: 'shard2', members: [ 
      { _id: 0, host: 'shard2a:27019', priority: 2 },
      { _id: 1, host: 'shard2b:27019', priority: 1 },
      { _id: 2, host: 'shard2c:27019', priority: 1 } ] });
    print('✅ shard2 инициализирован');
  } catch(e) {
    if (e.codeName === 'AlreadyInitialized') {
      print('ℹ shard2 уже инициализирован');
    } else {
      print('❌ Ошибка: ' + e.message);
      throw e;
    }
  }
"