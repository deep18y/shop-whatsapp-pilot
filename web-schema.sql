
CREATE TABLE IF NOT EXISTS web_sessions(id TEXT PRIMARY KEY,created_at INTEGER NOT NULL,requests INTEGER NOT NULL DEFAULT 0);
INSERT INTO settings(id,name,hours,contact,details) VALUES(1,'DEMO Grocery Store','Demo hours: daily 9am to 8pm','Demo only. No real owner phone configured.','Fictional demo. No payment, real fulfilment or owner push alert. Orders are demo pickup reservations only.') ON CONFLICT(id) DO NOTHING;
INSERT OR IGNORE INTO stock(sku,name,qty,price) VALUES('rice','Demo Rice 1kg pack',10,'Rs 60 / pack (demo)'),('milk','Demo Milk 1L carton',0,'Rs 55 / carton (demo)'),('bread','Demo Bread loaf',5,'Rs 40 / loaf (demo)');
