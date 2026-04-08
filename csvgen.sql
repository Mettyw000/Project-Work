-- 1. Tutti i dipendenti del reparto IT e Cybersecurity
SELECT 
    id_dipendente,
    nome,
    cognome,
    ruolo,
    email
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM dipendenti
WHERE ruolo IN ('CISO', 'CTO', 'IT Manager', 'SysAdmin', 'Specialista Cybersecurity', 
                'Tecnico di Rete', 'Help Desk IT');

-- 2. Fornitori con accesso privilegiato (VPN privilegiato o fisico completo) 
SELECT 
    id_fornitore,
    nome_azienda,
    contatto_emergenza,
    livello_accesso
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/fornitori_accesso_privilegiato.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM fornitori
WHERE livello_accesso IN ('Remoto VPN (Privilegiato)', 'Fisico Completo', 'Fisico e Remoto')
ORDER BY livello_accesso;

-- 3. Servizi critici ACN con RTO <= 4 ore e nome responsabile
SELECT 
    s.nome_servizio,
    s.criticita_acn,
    s.tempo_max_fermo_ore,
    CONCAT(d.nome, ' ', d.cognome) AS responsabile,
    d.ruolo,
    d.email
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/servizi_rto_sotto_4ore.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM servizi s
JOIN dipendenti d ON s.id_responsabile = d.id_dipendente
WHERE s.tempo_max_fermo_ore <= 4
ORDER BY s.tempo_max_fermo_ore ASC;

-- 4. Asset nella Linea Produzione con fornitore e proprietario
SELECT 
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione,
    CONCAT(d.nome, ' ', d.cognome) AS proprietario,
    f.nome_azienda AS fornitore,
    f.livello_accesso
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/asset_linea_produzione.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM asset a
JOIN dipendenti d ON a.id_proprietario = d.id_dipendente
JOIN fornitori f ON a.id_fornitore = f.id_fornitore
WHERE a.ubicazione LIKE '%Linea Produzione%'
ORDER BY a.ubicazione, a.tipo_asset;

-- 5. Asset nel Data Center con livello accesso fornitore
SELECT 
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione,
    f.nome_azienda AS fornitore,
    f.contatto_emergenza,
    f.livello_accesso
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/asset_data_center.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM asset a
JOIN fornitori f ON a.id_fornitore = f.id_fornitore
WHERE a.ubicazione LIKE '%Data Center%'
ORDER BY a.tipo_asset;

-- 6. Dipendenze con impatto BLOCCANTE su servizi ad alta criticità
SELECT 
    s.nome_servizio,
    s.criticita_acn,
    s.tempo_max_fermo_ore,
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione,
    das.impatto_guasto
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenze_bloccanti_alta_criticita.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM dipendenze_asset_servizio das
JOIN servizi s ON das.id_servizio = s.id_servizio
JOIN asset a ON das.id_asset = a.id_asset
WHERE das.impatto_guasto = 'Bloccante'
  AND s.criticita_acn = 'Alta'
ORDER BY s.tempo_max_fermo_ore ASC, a.nome_macchinario;

-- 7. Fornitori con accesso fisico che supportano asset bloccanti
SELECT 
    f.nome_azienda,
    f.contatto_emergenza,
    f.livello_accesso,
    a.nome_macchinario,
    a.ubicazione,
    s.nome_servizio,
    s.criticita_acn,
    das.impatto_guasto
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/rischio_fisico_fornitori.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM fornitori f
JOIN asset a ON a.id_fornitore = f.id_fornitore
JOIN dipendenze_asset_servizio das ON a.id_asset = das.id_asset
JOIN servizi s ON das.id_servizio = s.id_servizio
WHERE f.livello_accesso LIKE '%Fisico%'
  AND das.impatto_guasto = 'Bloccante'
ORDER BY s.criticita_acn, f.nome_azienda;

-- 8. Numero di asset bloccanti per ogni servizio (ranking esposizione)
SELECT 
    s.nome_servizio,
    s.criticita_acn,
    s.tempo_max_fermo_ore,
    COUNT(CASE WHEN das.impatto_guasto = 'Bloccante' THEN 1 END) AS asset_bloccanti,
    COUNT(CASE WHEN das.impatto_guasto = 'Degradazione' THEN 1 END) AS asset_degradazione,
    COUNT(CASE WHEN das.impatto_guasto = 'Trascurabile' THEN 1 END) AS asset_trascurabili,
    COUNT(*) AS totale_asset_dipendenti
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/ranking_esposizione_servizi.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM servizi s
LEFT JOIN dipendenze_asset_servizio das ON s.id_servizio = das.id_servizio
GROUP BY s.id_servizio, s.nome_servizio, s.criticita_acn, s.tempo_max_fermo_ore
ORDER BY s.criticita_acn, asset_bloccanti DESC;

-- 9. Asset condivisi tra più servizi (punti di failure multipla)
SELECT 
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione,
    COUNT(DISTINCT das.id_servizio) AS num_servizi_dipendenti,
    GROUP_CONCAT(s.nome_servizio ORDER BY s.nome_servizio SEPARATOR ' | ') AS servizi_collegati
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/asset_single_point_of_failure.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM asset a
JOIN dipendenze_asset_servizio das ON a.id_asset = das.id_asset
JOIN servizi s ON das.id_servizio = s.id_servizio
GROUP BY a.id_asset, a.nome_macchinario, a.tipo_asset, a.ubicazione
HAVING COUNT(DISTINCT das.id_servizio) > 1
ORDER BY num_servizi_dipendenti DESC;

-- 10. Scheda completa responsabili: servizi gestiti + asset sotto di loro
SELECT 
    CONCAT(d.nome, ' ', d.cognome) AS responsabile,
    d.ruolo,
    d.email,
    s.nome_servizio,
    s.criticita_acn,
    s.tempo_max_fermo_ore,
    COUNT(DISTINCT das.id_asset) AS num_asset_nel_servizio
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/scheda_responsabili_completa.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM dipendenti d
JOIN servizi s ON d.id_dipendente = s.id_responsabile
LEFT JOIN dipendenze_asset_servizio das ON s.id_servizio = das.id_servizio
GROUP BY d.id_dipendente, d.nome, d.cognome, d.ruolo, d.email,
         s.id_servizio, s.nome_servizio, s.criticita_acn, s.tempo_max_fermo_ore
ORDER BY s.criticita_acn, d.cognome;