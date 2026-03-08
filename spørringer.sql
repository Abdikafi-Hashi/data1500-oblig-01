 5.1
SELECT * FROM sykkel;

5.2
SELECT etternavn, fornavn, mobilnummer
FROM kunde
ORDER BY etternavn;

5.3
SELECT s.*
FROM sykkel s
JOIN utleie u ON s.sykkel_id = u.sykkel_id
WHERE u.utlevert > '2023-04-01';

 5.4
SELECT COUNT(*) AS antall_kunder
FROM kunde;

5.5 
SELECT k.kunde_id, k.fornavn, k.etternavn, COUNT(u.utleie_id) AS antall_utleier
FROM kunde k
LEFT JOIN utleie u ON k.kunde_id = u.kunde_id
GROUP BY k.kunde_id, k.fornavn, k.etternavn
ORDER BY k.kunde_id;

5.6 
SELECT k.*
FROM kunde k
LEFT JOIN utleie u ON k.kunde_id = u.kunde_id
WHERE u.utleie_id IS NULL;

5.7 
SELECT s.*
FROM sykkel s
LEFT JOIN utleie u ON s.sykkel_id = u.sykkel_id
WHERE u.utleie_id IS NULL;

5.8 
SELECT u.*, k.fornavn, k.etternavn, k.mobilnummer
FROM utleie u
JOIN kunde k ON u.kunde_id = k.kunde_id
WHERE u.innlevert IS NULL
   OR u.innlevert > u.utlevert + INTERVAL '1 day';
