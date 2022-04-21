DROP TABLE IF EXISTS prices;
DROP TYPE IF EXISTS FLUX;

CREATE TYPE FLUX AS ENUM ('volatile', 'fluid', 'stable', 'fixed');

CREATE TABLE prices(
  blightsource_id SERIAL REFERENCES blightsources (id),
  base_price INT NOT NULL,
  price_history INT[], /* https://www.postgresql.org/docs/current/intarray.html */
  volatility FLUX DEFAULT 'volatile'
);

WITH ins (name, base_price, price_history, volatility) AS
( VALUES
  ( 'forslone', 9, ARRAY [1], 'stable'),
  ( 'erecombe', 495, ARRAY [1], 'stable'),
  ( 'voidshimmer', 711, ARRAY [1], 'stable')
)  
INSERT INTO prices
  (blightsource_id, base_price, price_history, volatility) 
SELECT 
  blightsources.id, ins.base_price, ins.price_history, FLUX(ins.volatility)
FROM 
  blightsources JOIN ins
    ON ins.name = blightsources.name;