# StackExchange: DBA trainee test task

Инструкция по подготовке окружения и загрузке дампа сайта DBA.StackExchange  
(Ubuntu 22.04 + PostgreSQL 17)
## 1. Создание схемы
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
## 2. Импорт данных в БД
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
## 3. Запросы и планы запросов, подходы к их оптимизации
- Q1.sql - запрос Q1
- Q2.sql - запрос Q2
- Q1 explain analyze.csv - план запроса Q1
- Q1 explain analyze.csv - план запроса Q2
- Q1 result.png - результат запроса Q1 в metabase
- Q2 result.csv - результат запроса Q2

подходы к оптимизации запросов: 
- материализовать CTE
- после загрузки данных обновить статистику
- добавить индексы на столбцы, которые участвуют в WHERE и JOIN