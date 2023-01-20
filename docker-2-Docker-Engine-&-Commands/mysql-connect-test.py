import pymysql as sql

conn = sql.connect(
    host="127.0.0.1",
    user="root",
    port=9200,
    password="password1234!",
    db="example",
    charset="utf8"
)
cursor = conn.cursor(sql.cursors.DictCursor)
cursor.execute("SELECT 1+1")
print(cursor.fetchall())