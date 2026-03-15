CREATE ROLE kunde NOINHERIT;

GRANT SELECT ON kunde TO kunde;
GRANT SELECT ON stasjon TO kunde;
GRANT SELECT ON sykkel TO kunde;
GRANT SELECT ON utleie TO kunde;

CREATE USER kunde_1 WITH PASSWORD 'passord123';

GRANT kunde TO kunde_1;

CREATE VIEW mine_utleier AS
SELECT u.*
FROM utleie u
JOIN kunde k ON u.kunde_id = k.kunde_id
WHERE k.epost = current_user;

GRANT SELECT ON mine_utleier TO kunde;