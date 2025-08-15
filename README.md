# ⚡ EV Charging Station Utilization — SQL Project (Fresher Level)

## 📌 Objective
Use SQL to:
- Identify the busiest & most profitable stations
- Compare AC vs DC charger performance
- Find local peak demand hours by city
- Compute a simple utilization KPI to guide expansion

**Tech:** PostgreSQL (works with MySQL/SQLite with minor tweaks)

---

## 🧱 Tables
- **stations** (station_id, station_name, city)
- **chargers** (charger_id, station_id, charger_type = AC/DC)
- **sessions** (station_id, charger_id, plug_in_ts, charge_start_ts, charge_end_ts, kwh_delivered, price_per_kwh)

---

## ▶️ How to Run
In psql / pgAdmin Query Tool, run in this order:
```sql
\i sql/01_schema.sql
\i sql/02_sample_data.sql
\i sql/03_queries.sql
