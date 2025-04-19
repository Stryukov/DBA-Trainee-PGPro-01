# StackExchange Data Dump: DBA

Инструкция по подготовке окружения и загрузке дампа сайта DBA.StackExchange  
(Ubuntu 22.04 + PostgreSQL 17)
## 1. Установка дополнительных пакетов

```bash
sudo apt update
sudo apt install -y xmlstarlet postgresql-17-pg-bulkload
```

## 2. Создание схемы
Задайте имя пользователя и БД
```bash
PG_USER="dba_user"
PG_DB="stackexchange_dba"
```
Создайте роль и БД
```bash
sudo -u postgres psql <<SQL
  CREATE ROLE $PG_USER WITH LOGIN PASSWORD 'your_password';
  CREATE DATABASE $PG_DB OWNER $PG_USER;
  \q
SQL
```
Создайте схему
```bash
psql -U $PG_USER -d $PG_DB -f full_schema.sql
```
## 3. Импорт данных в БД
Сначала подготовим окружение
```bash
sudo apt install -y python3 python3-pip python3-venv
python3 -m venv venv
source venv/bin/activate

pip install pandas
```
Теперь импортируем данные
```bash
chmod +x import_all.sh
./import_all.sh
```
## 4. Запросы и планы запросов, подходы к их оптимизации




Идеи

2. 🔶 Уникальные индексы / обычные индексы
Их можно добавить вручную на часто используемые поля, например:

posts (owneruserid)

comments (postid)

votes (postid)

tags (tagname)

Это улучшит производительность запросов, особенно по JOIN'ам.