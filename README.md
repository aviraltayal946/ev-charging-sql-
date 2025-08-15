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

🔍 Key Queries

Q1. Sessions & total kWh by station
Q2. Revenue by station
Q3. Sessions by city
Q4. Avg charging time (minutes) by station
Q5. Sessions by charger type (AC/DC)
Q6. Peak hour overall
Q7. Daily kWh & revenue
Q8. Avg kWh per session by charger type
Q9. Top station per day (revenue leader)
Q10. City × hour (busiest hour by city)
Q11. Simple utilization proxy
Q12. Revenue per kWh (effective yield)

📈 Results (from my run on sample data)

Q1 (Busiest):
A = 3 sessions / 51.0 kWh · B = 2 / 39.0 · C = 1 / 16.0

Q2 (Revenue):
B = ₹1,060.8 · A = ₹800.4 · C = ₹211.2

Q3 (By City):
Bengaluru > Pune (2) > Delhi (1)

Q4 (Avg time min):
C = 39.0 · B = 36.0 · A = 35.0

Q5 (Type mix sessions):
From sample: DC shows higher energy per session than AC

Q6 (Peak hours overall):
7, 8, 9, 12, 18, 19 → tied (tiny sample)

Q7 (Best day):
2025-08-01 → 61.5 kWh / ₹1,116.0

Q8 (kWh/session):
DC ≈ 22.43 · AC ≈ 12.10

Q9 (Top station by day):
2025-08-01 → A (₹570.0) · 2025-08-02 → A (₹230.4) · 2025-08-03 → B (₹514.8)

Q10 (City × hour):
Bengaluru mornings (7–9h) · Pune evenings (18–19h) · Delhi midday (12h)

Q11 (Utilization proxy):
C = 0.0271 · A = 0.0182 · B = 0.0167 (small window; compare same ranges)

Q12 (Yield ₹/kWh):
B = 19.5 · A ≈ 17.29 · C = 16.0

✅ Summary Recommendations

Add 1 DC at Station A (busiest) and evaluate DC at Station C (long sessions).

Keep Station B premium (highest revenue/kWh); ensure DC uptime and test evening surge pricing.

Run intro offers/signage for Station C to lift sessions.

Schedule maintenance around local peaks: Bengaluru (7–9h), Pune (18–19h), Delhi (12h).

Collect 4–8 weeks of data before final capacity decisions; utilization stabilizes with more history.
