-- 01_schema.sql
-- EV Charging Station Utilization — SQL Project (Fresher Level)

DROP TABLE IF EXISTS sessions CASCADE;
DROP TABLE IF EXISTS chargers CASCADE;
DROP TABLE IF EXISTS stations CASCADE;

CREATE TABLE stations (
  station_id   SERIAL PRIMARY KEY,
  station_name TEXT NOT NULL,
  city         TEXT NOT NULL
);

CREATE TABLE chargers (
  charger_id   SERIAL PRIMARY KEY,
  station_id   INT REFERENCES stations(station_id),
  charger_type TEXT NOT NULL CHECK (charger_type IN ('AC','DC'))
);

CREATE TABLE sessions (
  session_id      SERIAL PRIMARY KEY,
  station_id      INT REFERENCES stations(station_id),
  charger_id      INT REFERENCES chargers(charger_id),
  plug_in_ts      TIMESTAMP NOT NULL,
  charge_start_ts TIMESTAMP NOT NULL,
  charge_end_ts   TIMESTAMP NOT NULL,
  kwh_delivered   NUMERIC(10,2) NOT NULL,
  price_per_kwh   NUMERIC(6,2)  NOT NULL
);
