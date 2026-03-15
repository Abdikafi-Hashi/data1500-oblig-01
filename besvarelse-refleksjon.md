Del 4: Analyse og Refleksjon

Oppgave 4.1: Lagringskapasitet

Jeg regner ut hvor mange utleier det blir totalt på ett år:

Høysesong (mai, juni, juli, august, september) = 5 måneder x 20000 = 100 000 utleier
Mellomsesong (mars, april, oktober, november) = 4 måneder x 5000 = 20 000 utleier
Lavsesong (desember, januar, februar) = 3 måneder x 500 = 1 500 utleier

Totalt = 121 500 utleier per år

Hver rad i utleie-tabellen inneholder omtrent:

- utleie_id: 4 bytes
- kunde_id: 4 bytes
- sykkel_id: 4 bytes
- utlevert: 8 bytes
- innlevert: 8 bytes
- beloep: 8 bytes
- overhead: 24 bytes

Totalt per rad = ca 60 bytes

Lagringsbehov for utleier = 121 500 x 60 bytes = ca 7,3 MB

Kunde, sykkel og stasjon-tabellene er små, så totalt estimat for første driftsår er ca 10-15 MB. Det er veldig lite for en moderne database.

Oppgave 4.2: Flat fil vs. relasjonsdatabase

En flat fil som utleier.csv lagrer alt på én lang rad per utleie. Dette gir to store problemer:

Redundans: Hvis Ali Hassan leier sykkel 10 ganger, skrives "Ali Hassan, ali@epost.no, 91234567" på alle 10 radene. Det er bortkastet plass og unødvendig repetisjon.

Inkonsistens: Hvis Ali bytter mobilnummer må vi oppdatere alle 10 radene. Glemmer vi én rad har vi to forskjellige nummer for samme person i samme fil.

I en relasjonsdatabase lagres Ali bare én gang i kunde-tabellen. Utleie-tabellen peker bare på kunde_id.

Hvorfor indeks hjelper: Uten indeks må databasen lese gjennom alle rader for å finne utleier for sykkel nummer 5, som å lete etter et ord i en bok uten innholdsfortegnelse. Med en indeks på sykkel_id kan databasen hoppe direkte til de riktige radene, som å bruke innholdsfortegnelsen.

Oppgave 4.3: Datastrukturer for logging

Den beste datastrukturen for logging er en heap-fil eller LSM-tree fordi de er optimalisert for å legge til data på slutten (append-only).

En logg trenger bare å skrive nye hendelser fortløpende, vi oppdaterer aldri gamle logg-rader. En heap-fil gjør dette veldig raskt fordi den bare legger til på slutten, akkurat som å skrive i en notatbok fra første til siste side.

En vanlig B-tree ville vært tregere fordi den må holde dataene sortert hele tiden, noe som krever ekstra arbeid ved hver skriving.

Oppgave 4.4: Validering i flerlags-systemer

Validering bør skje i alle lag, men av ulike grunner.

I nettleseren: Gir rask tilbakemelding til brukeren med én gang. Hvis man skriver inn bokstaver i mobilnummer-feltet, får man feilmelding uten å vente. Men dette er ikke trygt alene fordi en bruker kan omgå nettleseren og sende data direkte til serveren.

I applikasjonslaget (Java): Dette er det viktigste laget. Her sjekker vi at epost har @, at mobilnummer er 8 siffer, og at ingen felter er tomme. Vanskeligere å omgå enn nettleseren.

I databasen: Siste sikkerhetsnett. CHECK-constraints og NOT NULL avviser ugyldige data uansett hvordan de kom inn.

Konklusjon: Alle tre lag bør validere. Dette kalles "defence in depth", flere lag med forsvar.

Oppgave 4.5: Refleksjon over læringsutbytte

Før jeg startet dette emnet visste jeg ikke hva en database var utover at det var et sted man lagret data. Nå vet jeg hvordan man designer en database fra bunnen av. Jeg har lært å finne entiteter fra en beskrivelse, velge riktige datatyper, og koble tabeller med fremmednøkler. Normaliseringsoppgaven hjalp meg forstå hvorfor man ikke skal lagre samme informasjon flere steder.

Docker og PostgreSQL var helt nytt for meg, men nå klarer jeg å sette opp en database og kjøre SQL-spørringer selv. Det å se at SQL-koden faktisk fungerte og tabellene ble opprettet var veldig motiverende. Det mest nyttige var å jobbe med en hel prosess fra start til slutt, fra ER-diagram til ferdig database. Det ga meg en helhetlig forståelse som jeg ikke hadde fått av å bare lese pensum.
