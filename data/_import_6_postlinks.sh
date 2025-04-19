#!/bin/bash
set -e

XML_FILE="$DATA_DIR/PostLinks.xml"
CSV_FILE="$DATA_DIR/PostLinks.csv"

echo "🔄 Конвертация $XML_FILE → $CSV_FILE..."

python3 $DATA_DIR/_convert_with_pandas.py --file $XML_FILE --out $CSV_FILE --table postlinks

sed -i 's/"___NULL___"/\\N/g' "$CSV_FILE"

echo "📥 Импорт в PostgreSQL через COPY..."
psql -U "$PG_USER" -d "$PG_DB" <<EOF
\\COPY postlinks FROM '$CSV_FILE' WITH (FORMAT csv, HEADER, QUOTE '"', NULL '\\N');
EOF

echo "✅ Импорт PostLinks завершён!"