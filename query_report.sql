-- 1. Operatori CNC e Macchine SMT con i loro asset assegnati
SELECT
    CONCAT(d.nome, ' ', d.cognome) AS operatore,
    d.ruolo,
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione
FROM dipendenti d
JOIN asset a ON d.id_dipendente = a.id_proprietario
WHERE d.ruolo IN ('Operatore CNC', 'Operatore Macchine SMT')
ORDER BY d.ruolo, d.cognome;

-- 2. Fornitori senza alcun accesso (solo fornitura materiali)
SELECT
    id_fornitore,
    nome_azienda,
    contatto_emergenza,
    livello_accesso
FROM fornitori
WHERE livello_accesso = 'Nessun Accesso'
ORDER BY nome_azienda;

-- 3. Tutti gli asset nel Laboratorio R&D e Qualità con strumenti di misura
SELECT
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione,
    CONCAT(d.nome, ' ', d.cognome) AS responsabile,
    d.ruolo,
    f.nome_azienda AS fornitore
FROM asset a
JOIN dipendenti d ON a.id_proprietario = d.id_dipendente
JOIN fornitori f ON a.id_fornitore = f.id_fornitore
WHERE a.ubicazione LIKE '%Laboratorio%'
ORDER BY a.ubicazione, a.tipo_asset;

-- 4. Servizi a criticità BASSA con responsabile e tempo di fermo
SELECT
    s.nome_servizio,
    s.criticita_acn,
    s.tempo_max_fermo_ore,
    CONCAT(d.nome, ' ', d.cognome) AS responsabile,
    d.ruolo,
    d.email
FROM servizi s
JOIN dipendenti d ON s.id_responsabile = d.id_dipendente
WHERE s.criticita_acn = 'Bassa'
ORDER BY s.tempo_max_fermo_ore DESC;

-- 5. Asset di sicurezza fisica (videosorveglianza, antincendio, accessi)
SELECT
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione,
    CONCAT(d.nome, ' ', d.cognome) AS proprietario,
    f.nome_azienda AS fornitore,
    f.contatto_emergenza
FROM asset a
JOIN dipendenti d ON a.id_proprietario = d.id_dipendente
JOIN fornitori f ON a.id_fornitore = f.id_fornitore
WHERE a.tipo_asset IN ('Server Video', 'Controllo Accessi', 'Sicurezza')
   OR a.nome_macchinario LIKE '%Antincendio%'
   OR a.nome_macchinario LIKE '%Notifier%'
   OR a.nome_macchinario LIKE '%Varchi%'
ORDER BY a.tipo_asset;

-- 6. Asset in officina meccanica e area assemblaggio con impatto guasto
SELECT
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione,
    s.nome_servizio,
    s.criticita_acn,
    das.impatto_guasto,
    f.nome_azienda AS fornitore
FROM asset a
JOIN dipendenze_asset_servizio das ON a.id_asset = das.id_asset
JOIN servizi s ON das.id_servizio = s.id_servizio
JOIN fornitori f ON a.id_fornitore = f.id_fornitore
WHERE a.ubicazione IN ('Officina Meccanica', 'Area Assemblaggio', 'Area Rilavorazioni')
ORDER BY a.ubicazione, das.impatto_guasto;

-- 7. Dipendenti senza alcun asset assegnato (nessuna proprietà di asset)
SELECT
    d.id_dipendente,
    CONCAT(d.nome, ' ', d.cognome) AS dipendente,
    d.ruolo,
    d.email
FROM dipendenti d
LEFT JOIN asset a ON d.id_dipendente = a.id_proprietario
WHERE a.id_asset IS NULL
ORDER BY d.ruolo, d.cognome;

-- 8. Servizi con dipendenze di tipo Degradazione o Trascurabile (resilienza parziale)
SELECT
    s.nome_servizio,
    s.criticita_acn,
    s.tempo_max_fermo_ore,
    a.nome_macchinario,
    a.tipo_asset,
    das.impatto_guasto,
    CONCAT(d.nome, ' ', d.cognome) AS proprietario_asset
FROM dipendenze_asset_servizio das
JOIN servizi s ON das.id_servizio = s.id_servizio
JOIN asset a ON das.id_asset = a.id_asset
JOIN dipendenti d ON a.id_proprietario = d.id_dipendente
WHERE das.impatto_guasto IN ('Degradazione', 'Trascurabile')
ORDER BY s.criticita_acn, s.nome_servizio;

-- 9. Asset VM e Software con il cluster host e fornitore applicativo
SELECT
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione AS cluster_host,
    CONCAT(d.nome, ' ', d.cognome) AS amministratore,
    d.ruolo,
    f.nome_azienda AS fornitore_sw,
    f.livello_accesso
FROM asset a
JOIN dipendenti d ON a.id_proprietario = d.id_dipendente
JOIN fornitori f ON a.id_fornitore = f.id_fornitore
WHERE a.tipo_asset IN ('VM', 'Software')
ORDER BY a.ubicazione, a.nome_macchinario;

-- 10. Mappa completa del rischio: fornitore con accesso remoto privilegiato
--     su asset bloccanti per servizi con RTO <= 4 ore
SELECT
    f.nome_azienda AS fornitore_critico,
    f.contatto_emergenza,
    f.livello_accesso,
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione,
    s.nome_servizio,
    s.criticita_acn,
    s.tempo_max_fermo_ore AS rto_ore,
    das.impatto_guasto
FROM fornitori f
JOIN asset a ON a.id_fornitore = f.id_fornitore
JOIN dipendenze_asset_servizio das ON a.id_asset = das.id_asset
JOIN servizi s ON das.id_servizio = s.id_servizio
WHERE f.livello_accesso LIKE '%Privilegiato%'
  AND das.impatto_guasto = 'Bloccante'
  AND s.tempo_max_fermo_ore <= 4
ORDER BY s.tempo_max_fermo_ore ASC, f.nome_azienda;