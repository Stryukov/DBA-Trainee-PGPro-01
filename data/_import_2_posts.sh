#!/bin/bash
set -e

XML_FILE="$DATA_DIR/Posts.xml"
CSV_FILE="$DATA_DIR/Posts.csv"

echo "🔄 Конвертация $XML_FILE → $CSV_FILE..."

python3 $DATA_DIR/_convert_with_pandas.py --file $XML_FILE --out $CSV_FILE --table posts

sed -i 's/"___NULL___"/\\N/g' "$CSV_FILE"

echo "📥 Импорт в PostgreSQL через COPY..."
psql -h localhost -U "$PG_USER" -d "$PG_DB" <<EOF
\\COPY posts FROM '$CSV_FILE' WITH (FORMAT csv, HEADER, QUOTE '"', NULL '\\N');
EOF

echo "✅ Импорт posts завершён!"