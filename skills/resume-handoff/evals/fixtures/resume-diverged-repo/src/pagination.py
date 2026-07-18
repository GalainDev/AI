def list_items(offset, limit):
    return db.query(f"SELECT * FROM items OFFSET {offset} LIMIT {limit}")
