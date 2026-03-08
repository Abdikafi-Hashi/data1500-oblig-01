DROP TABLE IF EXISTS utleie CASCADE;
DROP TABLE IF EXISTS sykkel CASCADE;
DROP TABLE IF EXISTS stasjon CASCADE;
DROP TABLE IF EXISTS kunde CASCADE;

CREATE TABLE kunde (
    kunde_id    SERIAL PRIMARY KEY,
    fornavn     VARCHAR(100) NOT NULL,
    etternavn   VARCHAR(100) NOT NULL,
    epost       VARCHAR(255) NOT NULL UNIQUE,
    mobilnummer CHAR(8)      NOT NULL UNIQUE,
    CONSTRAINT chk_epost       CHECK (epost LIKE '%@%.%'),
    CONSTRAINT chk_mobilnummer CHECK (mobilnummer ~ '^[0-9]{8}$')
);

CREATE TABLE stasjon (
    stasjon_id SERIAL PRIMARY KEY,
    navn       VARCHAR(100) NOT NULL,
    adresse    VARCHAR(255) NOT NULL
);

CREATE TABLE sykkel (
    sykkel_id   SERIAL PRIMARY KEY,
    stasjon_id  INTEGER REFERENCES stasjon(stasjon_id),
    laas_nummer INTEGER,
    CONSTRAINT chk_stasjon_laas CHECK (
        (stasjon_id IS NULL AND laas_nummer IS NULL) OR
        (stasjon_id IS NOT NULL AND laas_nummer IS NOT NULL)
    )
);

CREATE TABLE utleie (
    utleie_id SERIAL PRIMARY KEY,
    kunde_id  INTEGER NOT NULL REFERENCES kunde(kunde_id),
    sykkel_id INTEGER NOT NULL REFERENCES sykkel(sykkel_id),
    utlevert  TIMESTAMP NOT NULL DEFAULT NOW(),
    innlevert TIMESTAMP,
    beloep    NUMERIC(10,2),
    CONSTRAINT chk_innlevert CHECK (innlevert IS NULL OR innlevert > utlevert),
    CONSTRAINT chk_beloep    CHECK (beloep IS NULL OR beloep >= 0)
);

INSERT INTO stasjon (navn, adresse) VALUES
    ('Jernbanetorget',   'Jernbanetorget 1, Oslo'),
    ('Aker Brygge',      'Stranden 3, Oslo'),
    ('Majorstuen',       'Bogstadveien 1, Oslo'),
    ('Grünerløkka',      'Thorvald Meyers gate 2, Oslo'),
    ('Nationaltheatret', 'Johanne Dybwads plass 1, Oslo');

INSERT INTO kunde (fornavn, etternavn, epost, mobilnummer) VALUES
    ('Ali',     'Hassan',   'ali.hassan@epost.no',     '91234567'),
    ('Fatima',  'Ahmed',    'fatima.ahmed@epost.no',   '92345678'),
    ('Erik',    'Hansen',   'erik.hansen@epost.no',    '93456789'),
    ('Maria',   'Olsen',    'maria.olsen@epost.no',    '94567890'),
    ('Jonas',   'Berg',     'jonas.berg@epost.no',     '95678901');

INSERT INTO sykkel (stasjon_id, laas_nummer)
SELECT stasjon_id, laas_nr
FROM generate_series(1, 5) AS stasjon_id,
     generate_series(1, 20) AS laas_nr;

UPDATE sykkel
SET stasjon_id = NULL, laas_nummer = NULL
WHERE sykkel_id IN (
    SELECT sykkel_id FROM sykkel ORDER BY sykkel_id LIMIT 50
);

INSERT INTO utleie (kunde_id, sykkel_id, utlevert, innlevert, beloep)
SELECT
    (((sykkel_id - 1) % 5) + 1),
    sykkel_id,
    NOW() - (random() * INTERVAL '30 days'),
    CASE WHEN sykkel_id % 5 = 0 THEN NULL
         ELSE NOW() - (random() * INTERVAL '10 days') END,
    CASE WHEN sykkel_id % 5 = 0 THEN NULL
         ELSE ROUND((random() * 100 + 10)::NUMERIC, 2) END
FROM sykkel
WHERE stasjon_id IS NULL;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;