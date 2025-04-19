import pandas as pd
import xml.etree.ElementTree as ET
import argparse
import csv

# Словарь известных схем
KNOWN_SCHEMAS = {
    "users": [
        "Id", "Reputation", "CreationDate", "DisplayName", "LastAccessDate",
        "WebsiteUrl", "Location", "AboutMe", "Views", "UpVotes", "DownVotes", "AccountId"
    ],
    "posts": [
        "Id", "PostTypeId", "CreationDate", "Score", "ViewCount", "Body",
        "OwnerUserId", "LastActivityDate", "Title", "Tags", "AnswerCount", "CommentCount",
        "ContentLicense", "ParentId", "LastEditorUserId", "LastEditDate",
        "AcceptedAnswerId", "ClosedDate"
    ],
    "comments": [
        "Id", "PostId", "Score", "Text", "CreationDate", "UserId"
    ],
    "votes": [
        "Id", "PostId", "VoteTypeId", "CreationDate"
    ],
    "tags": [
        "Id", "TagName", "Count", "IsRequired", "ExcerptPostId", "WikiPostId", "IsModeratorOnly"
    ],
    "posthistory": [
        "Id", "PostHistoryTypeId", "PostId", "RevisionGUID", "CreationDate",
        "UserId", "Text", "ContentLicense", "Comment"
    ],
    "postlinks": [
        "Id", "CreationDate", "PostId", "RelatedPostId", "LinkTypeId"
    ],
    "badges": [
        "Id", "UserId", "Name", "Date", "Class", "TagBased"
    ]
}

def convert_with_pandas(xml_path, csv_path, table_name):
    if table_name not in KNOWN_SCHEMAS:
        raise ValueError(f"Неизвестная таблица: {table_name}")
    
    columns = KNOWN_SCHEMAS[table_name]
    rows = []

    for event, elem in ET.iterparse(xml_path, events=("start",)):
        if elem.tag != "row":
            continue
        row = {col: elem.attrib.get(col) for col in columns}
        rows.append(row)

    df = pd.DataFrame(rows)

    # Заменяем переносы строк на \\n в текстовых полях
    for col in ["Body", "AboutMe", "Text", "Comment"]:
        if col in df.columns:
            df[col] = df[col].astype(str).str.replace('\n', '\\n')

    # Пишем CSV с экранированными кавычками и явным NULL-маркером
    with open(csv_path, mode="w", newline="", encoding="utf-8") as f:
        df.to_csv(
            f,
            index=False,
            quoting=csv.QUOTE_ALL,
            na_rep='___NULL___',
            doublequote=True
        )

    print(f"{len(df)} строк сохранено в {csv_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Конвертация StackExchange XML в CSV с pandas")
    parser.add_argument("--file", required=True, help="Путь к XML-файлу")
    parser.add_argument("--out", required=True, help="Путь к выходному CSV")
    parser.add_argument("--table", required=True, help="Имя таблицы (users, posts, comments, ...)")

    args = parser.parse_args()
    convert_with_pandas(args.file, args.out, args.table)
