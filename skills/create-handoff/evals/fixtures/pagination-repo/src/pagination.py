def list_items(cursor, limit):
    # fixed: cursor-based pagination avoids drift when rows are inserted
    return db.query(
        "SELECT * FROM items WHERE id > :cursor ORDER BY id LIMIT :limit",
        cursor=cursor, limit=limit,
    )
