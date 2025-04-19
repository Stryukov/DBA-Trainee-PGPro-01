#!/bin/bash
set -e

export DATA_DIR="./data"

echo "DB: $PG_DB | USER: $PG_USER | DATA_DIR: $DATA_DIR"

# Запуск всех скриптов из папки $DATA_DIR
echo "🚀 Последовательный запуск скриптов импорта из $DATA_DIR"
for script in "$DATA_DIR"/_import_*.sh; do
  chmod +x "$script"
  bash "$script"
done

echo "🎉 Импорт данных завершён!"
