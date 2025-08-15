-- 03_queries.sql
-- 12 fresher-friendly queries (PostgreSQL). ROUND() needs numeric, so we cast.

-- Q1: Sessions & total kWh by station
SELECT st.station_name,
       COUNT(*) AS sessions,
       SUM(s.kwh_delivered) AS total_kwh
FROM sessions s
JOIN stations st USING(station_id)
GROUP BY st.station_name
ORDER BY sessions DESC, total_kwh DESC;

-- Q2: Revenue by station
SELECT st.station_name,
       SUM(s.kwh_delivered * s.price_per_kwh) AS revenue
FROM sessions s
JOIN stations st USING(station_id)
GROUP BY st.station_name
ORDER BY revenue DESC;

-- Q3: Sessions by city
SELECT st.city, COUNT(*) AS sessions
FROM sessions s
JOIN stations st USING(station_id)
GROUP BY st.city
ORDER BY sessions DESC;

-- Q4: Avg charging time (minutes) by station
SELECT st.station_name,
       ROUND(
         AVG(EXTRACT(EPOCH FROM (s.charge_end_ts - s.charge_start_ts))/60.0)::numeric
       , 1) AS avg_charge_min
FROM sessions s
JOIN stations st USING(station_id)
GROUP BY st.station_name
ORDER BY avg_charge_min DESC;

-- Q5: Sessions by charger type (AC vs DC)
SELECT c.charger_type, COUNT(*) AS sessions
FROM sessions s
JOIN chargers c USING(charger_id)
GROUP BY c.charger_type
ORDER BY sessions DESC;

-- Q6: Peak hour overall (hour with most sessions)
SELECT DATE_PART('hour', charge_start_ts) AS hr,
       COUNT(*) AS sessions
FROM sessions
GROUP BY hr
ORDER BY sessions DESC, hr;

-- Q7: Daily kWh & revenue (simple trend)
SELECT DATE(charge_start_ts) AS day,
       SUM(kwh_delivered) AS kwh,
       SUM(kwh_delivered * price_per_kwh) AS revenue
FROM sessions
GROUP BY day
ORDER BY day;

-- Q8: Avg kWh per session by charger type
SELECT c.charger_type,
       ROUND(AVG(s.kwh_delivered)::numeric, 5) AS avg_kwh_per_session
FROM sessions s
JOIN chargers c USING(charger_id)
GROUP BY c.charger_type
ORDER BY avg_kwh_per_session DESC;

-- Q9: Top station per day by revenue (ranking)
SELECT day, station_name, revenue
FROM (
  SELECT DATE(s.charge_start_ts) AS day,
         st.station_name,
         SUM(s.kwh_delivered * s.price_per_kwh) AS revenue,
         ROW_NUMBER() OVER (
            PARTITION BY DATE(s.charge_start_ts)
            ORDER BY SUM(s.kwh_delivered * s.price_per_kwh) DESC
         ) AS rn
  FROM sessions s
  JOIN stations st USING(station_id)
  GROUP BY day, st.station_name
) x
WHERE rn = 1
ORDER BY day, revenue DESC;

-- Q10: City × hour grid (busiest hour per city perspective)
SELECT st.city,
       DATE_PART('hour', s.charge_start_ts) AS hr,
       COUNT(*) AS sessions
FROM sessions s
JOIN stations st USING(station_id)
GROUP BY st.city, hr
ORDER BY st.city, sessions DESC, hr;

-- Q11: Simple utilization proxy (no outages)
-- utilization = total charging seconds / (charger_count * 24h * number_of_days)
WITH charge_time AS (
  SELECT st.station_id,
         SUM(EXTRACT(EPOCH FROM (s.charge_end_ts - s.charge_start_ts))) AS charge_secs,
         MIN(DATE(s.charge_start_ts)) AS dmin,
         MAX(DATE(s.charge_end_ts))   AS dmax
  FROM sessions s
  JOIN stations st USING(station_id)
  GROUP BY st.station_id
),
capacity AS (
  SELECT st.station_id,
         COUNT(c.charger_id) AS charger_count
  FROM stations st
  JOIN chargers c USING(station_id)
  GROUP BY st.station_id
)
SELECT st.station_name,
       ROUND( (charge_secs / NULLIF(charger_count * 24*3600 * (dmax - dmin + 1), 0))::numeric
       , 4) AS utilization_ratio
FROM charge_time
JOIN capacity USING(station_id)
JOIN stations st USING(station_id)
ORDER BY utilization_ratio DESC NULLS LAST;

-- Q12: Revenue per kWh (effective yield)
SELECT st.station_name,
       SUM(s.kwh_delivered * s.price_per_kwh) / NULLIF(SUM(s.kwh_delivered),0) AS revenue_per_kwh
FROM sessions s
JOIN stations st USING(station_id)
GROUP BY st.station_name
ORDER BY revenue_per_kwh DESC;
