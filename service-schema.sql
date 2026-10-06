
CREATE TABLE IF NOT EXISTS service_profiles(shop_id TEXT PRIMARY KEY,business_type TEXT NOT NULL DEFAULT 'service',working_days TEXT NOT NULL DEFAULT 'Mon,Tue,Wed,Thu,Fri',address TEXT NOT NULL DEFAULT '',services TEXT NOT NULL DEFAULT '',fees TEXT NOT NULL DEFAULT '',timezone TEXT NOT NULL DEFAULT 'Asia/Kolkata',FOREIGN KEY(shop_id) REFERENCES shops(id));
CREATE TABLE IF NOT EXISTS appointment_slots(id TEXT PRIMARY KEY,shop_id TEXT NOT NULL,starts_at TEXT NOT NULL,ends_at TEXT NOT NULL,service TEXT NOT NULL,status TEXT NOT NULL DEFAULT 'available' CHECK(status IN('available','booked','closed')),UNIQUE(shop_id,starts_at),FOREIGN KEY(shop_id) REFERENCES shops(id));
CREATE TABLE IF NOT EXISTS appointments(id TEXT PRIMARY KEY,shop_id TEXT NOT NULL,slot_id TEXT NOT NULL UNIQUE,customer_name TEXT NOT NULL,contact TEXT NOT NULL,created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY(slot_id) REFERENCES appointment_slots(id),FOREIGN KEY(shop_id) REFERENCES shops(id));
CREATE TRIGGER IF NOT EXISTS reserve_appointment BEFORE INSERT ON appointments BEGIN
 SELECT CASE WHEN NOT EXISTS(SELECT 1 FROM appointment_slots WHERE id=NEW.slot_id AND shop_id=NEW.shop_id AND status='available') THEN RAISE(ABORT,'slot_unavailable') END;
 UPDATE appointment_slots SET status='booked' WHERE id=NEW.slot_id AND shop_id=NEW.shop_id;
END;

CREATE TRIGGER IF NOT EXISTS no_overlapping_slots BEFORE INSERT ON appointment_slots BEGIN
 SELECT CASE WHEN EXISTS(SELECT 1 FROM appointment_slots WHERE shop_id=NEW.shop_id AND status!='closed' AND starts_at<NEW.ends_at AND ends_at>NEW.starts_at) THEN RAISE(ABORT,'overlapping_slot') END;
END;
