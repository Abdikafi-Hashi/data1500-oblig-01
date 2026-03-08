CREATE ROLE kunde NOINHERIT;

GRANT SELECT ON kunde TO kunde;
GRANT SELECT ON stasjon TO kunde;
GRANT SELECT ON sykkel TO kunde;
GRANT SELECT ON utleie TO kunde;

CREATE USER kunde_1 WITH PASSWORD 'passord123';

GRANT kunde TO kunde_1;

CREATE VIEW kunde_utleier AS
SELECT *
FROM utleie
WHERE kunde_id = 1;

GRANT SELECT ON kunde_utleier TO kunde;
