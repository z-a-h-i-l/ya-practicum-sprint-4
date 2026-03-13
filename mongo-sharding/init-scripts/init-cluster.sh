# Инициализация config_server
mongosh --host configSrv:27017 --eval "
  try {
    rs.initiate({ _id: 'config_server', configsvr: true, members: [ { _id: 0, host: 'configSrv:27017' } ] });
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

# Инициализация shard1
mongosh --host shard1:27018 --eval "
  try {
    rs.initiate({ _id: 'shard1', members: [ { _id: 0, host: 'shard1:27018' } ] });
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
# Инициализация shard2
mongosh --host shard2:27019 --eval "
  try {
    rs.initiate({ _id: 'shard2', members: [ { _id: 0, host: 'shard2:27019' } ] });
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