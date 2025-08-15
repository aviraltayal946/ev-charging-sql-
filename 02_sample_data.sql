-- 02_sample_data.sql
-- Tiny sample so queries show real outputs

INSERT INTO stations (station_name, city) VALUES
('GreenCharge A','Bengaluru'),
('GreenCharge B','Pune'),
('GreenCharge C','Delhi');

INSERT INTO chargers (station_id, charger_type) VALUES
(1,'DC'), (1,'AC'), (2,'DC'), (3,'AC');

INSERT INTO sessions
(station_id, charger_id, plug_in_ts, charge_start_ts, charge_end_ts, kwh_delivered, price_per_kwh) VALUES
(1,1,'2025-08-01 08:05','2025-08-01 08:06','2025-08-01 08:40',22.50,18.00),
(1,2,'2025-08-01 09:10','2025-08-01 09:12','2025-08-01 10:00',11.00,15.00),
(2,3,'2025-08-01 18:20','2025-08-01 18:21','2025-08-01 18:50',28.00,19.50),
(1,1,'2025-08-02 07:00','2025-08-02 07:02','2025-08-02 07:25',12.80,18.00),
(3,4,'2025-08-02 12:15','2025-08-02 12:16','2025-08-02 12:55',13.20,16.00),
(2,3,'2025-08-03 19:10','2025-08-03 19:12','2025-08-03 19:55',26.40,19.50);
