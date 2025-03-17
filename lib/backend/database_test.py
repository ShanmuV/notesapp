import sqlite3
import os

conn = sqlite3.connect("FileDatabase.db")
cursor = conn.cursor()

# cursor.execute("ALTER TABLE Files RENAME TO old_table;")

# cursor.execute("""CREATE TABLE IF NOT EXISTS Files(
#                     ID INTEGER PRIMARY KEY AUTOINCREMENT,
#                     Subject TEXT,
#                     Name TEXT,
#                     Author TEXT,
#                     Desc TEXT
#                );""")

# cursor.execute("INSERT INTO FILES( Subject, Name, Author, Desc) VALUES( 'Maths', 'Name1', 'Author1', 'Description about Notes');")
# cursor.execute("INSERT INTO FILES( Subject, Name, Author, Desc) VALUES( 'Maths', 'Name2', 'Author2', 'Description about Notes');")
# cursor.execute("INSERT INTO FILES( Subject, Name, Author, Desc) VALUES( 'Maths', 'Name3', 'Author3', 'Description about Notes');")

# cursor.execute("INSERT INTO FILES( Subject, Name, Author, Desc) VALUES( 'Science', 'Name4', 'Author4', 'Description about Notes');")
# cursor.execute("INSERT INTO FILES( Subject, Name, Author, Desc) VALUES( 'Science', 'Name5', 'Author5', 'Description about Notes');")

# cursor.execute("INSERT INTO FILES( Subject, Name, Author, Desc) VALUES( 'Computer Science', 'Name6', 'Author6', 'Description about Notes');")
# cursor.execute("INSERT INTO FILES( Subject, Name, Author, Desc) VALUES( 'Computer Science', 'Name7', 'Author7', 'Description about Notes');")
# cursor.execute("INSERT INTO FILES( Subject, Name, Author, Desc) VALUES( 'Computer Science', 'Name8', 'Author8', 'Description about Notes');")
# cursor.execute("INSERT INTO FILES( Subject, Name, Author, Desc) VALUES( 'Computer Science', 'Name9', 'Author9', 'Description about Notes');")

# rows = cursor.execute("Select * from Files;")
# for row in rows:
#     print(row)

# cursor.execute("Drop Table old_table;")

cursor.execute("Delete from Files where id = 10")

conn.commit()