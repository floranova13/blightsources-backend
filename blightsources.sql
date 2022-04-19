DROP TABLE IF EXISTS blightsources;

CREATE TABLE blightsources (
  id SERIAL PRIMARY KEY NOT NULL,
  name TEXT NOT NULL
);

INSERT INTO blightsources (name)
VALUES
    ('forslone'),
    ('erecombe'),
    ('voidshimmer');