WITH ins (name, base_price, price_history, volatility) AS
( VALUES
  ( 'forslone', 9, [], 'stable'),
  ( 'erecombe', 495, [], 'stable'),
  ( 'voidshimmer', 711, [], 'stable')
)  
INSERT INTO prices
  (blightsource_id, base_price, price_history, volatility) 
SELECT 
  blightsources.id, ins.base_price, ins.price_history, ins.volatility
FROM 
  blightsources JOIN ins
    ON ins.name = blightsources.name;