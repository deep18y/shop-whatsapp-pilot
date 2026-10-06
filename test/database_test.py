
import sqlite3,pathlib
c=sqlite3.connect(':memory:');c.executescript(pathlib.Path(__file__).parents[1].joinpath('schema.sql').read_text())
c.execute("INSERT INTO stock(sku,name,qty) VALUES('rice','Rice',3)")
c.execute("INSERT INTO orders(id,customer,sku,qty,pickup) VALUES('one','test','rice',2,'6pm')")
assert c.execute("SELECT qty FROM stock").fetchone()[0]==1
try:c.execute("INSERT INTO orders(id,customer,sku,qty,pickup) VALUES('two','test','rice',2,'7pm')");raise AssertionError('Oversold')
except sqlite3.IntegrityError:pass
assert c.execute("SELECT qty FROM stock").fetchone()[0]==1
try:c.execute("INSERT INTO orders(id,customer,sku,qty,pickup) VALUES('one','test','rice',1,'6pm')")
except sqlite3.IntegrityError:pass
assert c.execute("SELECT qty FROM stock").fetchone()[0]==1
assert c.execute("SELECT count(*) FROM orders").fetchone()[0]==1
print('Database tests passed: atomic reserve, oversell rejection, duplicate order rollback')
