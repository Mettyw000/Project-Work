SELECT
    r.Servizio_Critico,
    r.Classe_Critica_ACN,
    r.Asset_Tecnologico,
    r.Categoria_Risorsa,
    r.Punto_Contatto_Responsabile,
    r.Email_Referente,
    r.Supporto_Terze_Parti,
    CASE
        WHEN r.Supporto_Terze_Parti = 'Manutenzione Interna' THEN 'Interno'
        ELSE 'Esterno'
    END
FROM report_conformita_acn r
ORDER BY FIELD(Classe_Critica_ACN, 'Alta', 'Media', 'Bassa'), Servizio_Critico
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT
    r.Asset_Tecnologico,
    r.Categoria_Risorsa,
    r.Servizio_Critico,
    r.Classe_Critica_ACN,
    r.Supporto_Terze_Parti,
    CAST(s.tempo_max_fermo_ore AS CHAR)
FROM report_conformita_acn r
JOIN servizi s ON s.nome_servizio = r.Servizio_Critico
WHERE r.Classe_Critica_ACN = 'Alta'
ORDER BY s.tempo_max_fermo_ore ASC
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT
    f.nome_azienda,
    COALESCE(f.livello_accesso, 'Non specificato'),
    COALESCE(f.contatto_emergenza, 'N/D'),
    CAST(COUNT(DISTINCT a.id_asset) AS CHAR),
    CAST(COUNT(DISTINCT ril.id_rilevazione) AS CHAR),
    COALESCE(CAST(MAX(v.cvss_score) AS CHAR), '0'),
    COALESCE(GROUP_CONCAT(DISTINCT v.codice_cve ORDER BY v.cvss_score DESC SEPARATOR ' | '), 'Nessuna')
FROM fornitori f
JOIN asset                   a   ON a.id_fornitore      = f.id_fornitore
LEFT JOIN rilevazioni_sicurezza ril ON ril.id_asset     = a.id_asset
                                    AND ril.stato_remediation NOT IN ('Risolta','Rischio Accettato')
LEFT JOIN vulnerabilita      v   ON ril.id_vulnerabilita = v.id_vulnerabilita
GROUP BY f.id_fornitore, f.nome_azienda, f.livello_accesso, f.contatto_emergenza
ORDER BY COUNT(DISTINCT ril.id_rilevazione) DESC
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT
    ms.funzione_acn,
    ms.codice,
    ms.nome,
    CAST(pm_c.livello_maturita AS CHAR),
    CAST(pm_o.livello_maturita AS CHAR),
    CAST(pm_o.livello_maturita - pm_c.livello_maturita AS CHAR),
    ga.priorita,
    COALESCE(ga.piano_azione, 'Da definire'),
    COALESCE(CONCAT(d.nome,' ',d.cognome), 'Non assegnato'),
    COALESCE(d.email, 'N/D'),
    COALESCE(CAST(ga.scadenza AS CHAR), 'N/D'),
    COALESCE(CAST(DATEDIFF(ga.scadenza, CURDATE()) AS CHAR), 'N/D'),
    CASE
        WHEN ga.scadenza < CURDATE()                        THEN 'SCADUTO'
        WHEN DATEDIFF(ga.scadenza, CURDATE()) <= 30         THEN 'URGENTE'
        WHEN DATEDIFF(ga.scadenza, CURDATE()) <= 90         THEN 'ATTENZIONE'
        ELSE                                                     'IN_TEMPO'
    END
FROM gap_analisi ga
JOIN misura_sicurezza ms ON ga.id_misura          = ms.id_misura
JOIN profilo_misura pm_c ON pm_c.id_misura        = ga.id_misura
                         AND pm_c.id_profilo       = ga.id_profilo_corrente
JOIN profilo_misura pm_o ON pm_o.id_misura        = ga.id_misura
                         AND pm_o.id_profilo       = ga.id_profilo_obiettivo
LEFT JOIN dipendenti d   ON ga.id_responsabile    = d.id_dipendente
WHERE pm_o.livello_maturita > pm_c.livello_maturita
ORDER BY FIELD(ga.priorita,'Alta','Media','Bassa'), ga.scadenza ASC
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT
    CAST(pa.id_profilo AS CHAR),
    pa.tipo,
    pa.versione,
    CAST(pa.data_valutazione AS CHAR),
    COALESCE(CONCAT(d.nome,' ',d.cognome), 'N/D'),
    CAST(COUNT(pm.id_profilo_misura) AS CHAR),
    CAST(SUM(CASE WHEN pm.stato = 'Conforme'        THEN 1 ELSE 0 END) AS CHAR),
    CAST(SUM(CASE WHEN pm.stato = 'Parziale'        THEN 1 ELSE 0 END) AS CHAR),
    CAST(SUM(CASE WHEN pm.stato = 'Non valutato'    THEN 1 ELSE 0 END) AS CHAR),
    CAST(SUM(CASE WHEN pm.stato = 'Non applicabile' THEN 1 ELSE 0 END) AS CHAR),
    CAST(ROUND(100.0 * SUM(CASE WHEN pm.stato='Conforme' THEN 1 ELSE 0 END)
               / NULLIF(COUNT(pm.id_profilo_misura),0), 1) AS CHAR),
    CAST(ROUND(AVG(pm.livello_maturita), 2) AS CHAR)
FROM profilo_acn pa
LEFT JOIN profilo_misura pm ON pa.id_profilo      = pm.id_profilo
LEFT JOIN dipendenti     d  ON pa.id_responsabile = d.id_dipendente
GROUP BY pa.id_profilo, pa.tipo, pa.versione, pa.data_valutazione, d.nome, d.cognome
ORDER BY pa.data_valutazione DESC, pa.tipo
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT
    a.nome_macchinario,
    a.tipo_asset,
    a.ubicazione,
    COALESCE(v.codice_cve, 'N/D'),
    v.severita,
    CAST(v.cvss_score AS CHAR),
    v.descrizione,
    COALESCE(v.soluzione_consigliata, 'N/D'),
    ril.stato_remediation,
    COALESCE(CAST(ril.data_scadenza_patch AS CHAR), 'N/D'),
    COALESCE(CAST(DATEDIFF(ril.data_scadenza_patch, CURDATE()) AS CHAR), 'N/D'),
    CONCAT(d.nome,' ',d.cognome)
FROM rilevazioni_sicurezza ril
JOIN asset         a ON ril.id_asset         = a.id_asset
JOIN vulnerabilita v ON ril.id_vulnerabilita = v.id_vulnerabilita
JOIN dipendenti    d ON a.id_proprietario    = d.id_dipendente
WHERE v.cvss_score >= 7.0
  AND ril.stato_remediation NOT IN ('Risolta','Rischio Accettato')
ORDER BY v.cvss_score DESC, ril.data_scadenza_patch ASC
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT
    CAST(asm.id_assessment AS CHAR),
    asm.tipo_test,
    CAST(asm.data_esecuzione AS CHAR),
    COALESCE(CONCAT(d.nome,' ',d.cognome), '–'),
    COALESCE(f.nome_azienda, '–'),
    CAST(COUNT(ril.id_rilevazione) AS CHAR),
    CAST(SUM(CASE WHEN v.severita = 'Critica' THEN 1 ELSE 0 END) AS CHAR),
    CAST(SUM(CASE WHEN v.severita = 'Alta'    THEN 1 ELSE 0 END) AS CHAR),
    CAST(SUM(CASE WHEN v.severita = 'Media'   THEN 1 ELSE 0 END) AS CHAR),
    CAST(SUM(CASE WHEN v.severita = 'Bassa'   THEN 1 ELSE 0 END) AS CHAR),
    CAST(SUM(CASE WHEN ril.stato_remediation = 'Risolta' THEN 1 ELSE 0 END) AS CHAR),
    COALESCE(asm.report_file_path, 'N/D')
FROM assessment asm
LEFT JOIN dipendenti            d   ON asm.esecutore_interno_id = d.id_dipendente
LEFT JOIN fornitori             f   ON asm.fornitore_esterno_id = f.id_fornitore
LEFT JOIN rilevazioni_sicurezza ril ON asm.id_assessment        = ril.id_assessment
LEFT JOIN vulnerabilita         v   ON ril.id_vulnerabilita     = v.id_vulnerabilita
GROUP BY asm.id_assessment, asm.tipo_test, asm.data_esecuzione,
         d.nome, d.cognome, f.nome_azienda, asm.report_file_path
ORDER BY asm.data_esecuzione DESC
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT
    CAST(s.data_modifica AS CHAR),
    a.nome_macchinario,
    COALESCE(a.tipo_asset, 'N/D'),
    COALESCE(a.ubicazione, 'N/D'),
    CONCAT(d_old.nome,' ',d_old.cognome),
    CONCAT(d_new.nome,' ',d_new.cognome),
    d_new.email,
    COALESCE(s.nota_modifica, 'N/D')
FROM storico_asset  s
JOIN asset      a     ON s.id_asset              = a.id_asset
JOIN dipendenti d_old ON s.vecchio_proprietario_id = d_old.id_dipendente
JOIN dipendenti d_new ON a.id_proprietario        = d_new.id_dipendente
ORDER BY s.data_modifica DESC
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT
    CAST(ms.id_misura AS CHAR),
    ms.codice,
    ms.funzione_acn,
    ms.nome,
    COALESCE(ms.descrizione, 'N/D'),
    CAST(ms.livello_minimo AS CHAR)
FROM misura_sicurezza ms
ORDER BY
    FIELD(ms.funzione_acn,'GV','ID','PR','DE','RS','RC'),
    ms.codice
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';


SELECT
    CAST(d.id_dipendente AS CHAR),
    CONCAT(d.nome,' ',d.cognome),
    d.ruolo,
    d.email,
    CAST(COUNT(DISTINCT s.id_servizio)  AS CHAR),
    CAST(COUNT(DISTINCT a.id_asset)     AS CHAR),
    CAST(COUNT(DISTINCT pa.id_profilo)  AS CHAR),
    CAST(COUNT(DISTINCT ga.id_gap)      AS CHAR),
    CAST(SUM(CASE WHEN ga.priorita = 'Alta' THEN 1 ELSE 0 END) AS CHAR),
    COALESCE(CAST(MIN(ga.scadenza) AS CHAR), 'Nessun gap')
FROM dipendenti d
LEFT JOIN servizi     s  ON s.id_responsabile  = d.id_dipendente
LEFT JOIN asset       a  ON a.id_proprietario  = d.id_dipendente
LEFT JOIN profilo_acn pa ON pa.id_responsabile = d.id_dipendente
LEFT JOIN gap_analisi ga ON ga.id_responsabile = d.id_dipendente
GROUP BY d.id_dipendente, d.nome, d.cognome, d.ruolo, d.email
HAVING COUNT(DISTINCT s.id_servizio) > 0
    OR COUNT(DISTINCT a.id_asset)    > 0
    OR COUNT(DISTINCT pa.id_profilo) > 0
    OR COUNT(DISTINCT ga.id_gap)     > 0
ORDER BY
    SUM(CASE WHEN ga.priorita='Alta' THEN 1 ELSE 0 END) DESC,
    COUNT(DISTINCT ga.id_gap) DESC
INTO OUTFILE 'C:/Users/Aorus/OneDrive/Desktop/Project-Work/dipendenti_it_cyber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';