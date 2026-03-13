# Запуск кластера


1. Выполнить команду запуска `docker compose`
```bash
docker compose up -d
```
2. Заполнить базу тестовыми данными
```bash
docker exec -it mongos_router mongosh --port 27020 --eval "
  for (var i = 0; i < 1000; i++) {
    db.getSiblingDB('somedb').helloDoc.insertOne({ age: i, name: 'ly' + i });
  }
  print('Вставлено 1000 документов');
"
```
3. Проверить количество документов
```bash
docker exec -it mongos_router mongosh --port 27020 --eval "
  print('Количество документов: ' + db.getSiblingDB('somedb').helloDoc.countDocuments());
"
```

4. Очистить кластер
```bash
docker compose down -v
```