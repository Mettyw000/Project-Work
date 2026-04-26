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
        ELSE 'Esterno – verifica contratto NIS2'
    END AS Tipo_Supporto
FROM report_conformita_acn r
ORDER BY
    FIELD(r.Classe_Critica_ACN, 'Alta', 'Media', 'Bassa'),
    r.Servizio_Critico;


SELECT
    r.Asset_Tecnologico,
    r.Categoria_Risorsa,
    r.Servizio_Critico,
    r.Classe_Critica_ACN,
    r.Supporto_Terze_Parti,
    s.tempo_max_fermo_ore AS Max_Fermo_Ore
FROM report_conformita_acn r
JOIN servizi s ON s.nome_servizio = r.Servizio_Critico
WHERE r.Classe_Critica_ACN = 'Alta'
ORDER BY s.tempo_max_fermo_ore ASC;   -- prima i servizi meno tolleranti ai fermi


SELECT
    r.Asset_Tecnologico,
    r.Categoria_Risorsa,
    r.Servizio_Critico,
    r.Supporto_Terze_Parti,
    f.livello_accesso,
    r.Punto_Contatto_Responsabile,
    r.Email_Referente,
    COUNT(*) OVER (PARTITION BY r.Supporto_Terze_Parti) AS Asset_Per_Fornitore
FROM report_conformita_acn r
JOIN fornitori f ON f.nome_azienda = r.Supporto_Terze_Parti
WHERE r.Supporto_Terze_Parti != 'Manutenzione Interna'
ORDER BY Asset_Per_Fornitore DESC, r.Servizio_Critico;


SELECT
    s.data_modifica,
    a.nome_macchinario                          AS Asset,
    a.tipo_asset                                AS Tipo,
    a.ubicazione                                AS Ubicazione,
    CONCAT(d_old.nome, ' ', d_old.cognome)      AS Vecchio_Responsabile,
    CONCAT(d_new.nome, ' ', d_new.cognome)      AS Responsabile_Attuale,
    s.nota_modifica                             AS Nota
FROM storico_asset s
JOIN asset      a     ON s.id_asset              = a.id_asset
JOIN dipendenti d_old ON s.vecchio_proprietario_id = d_old.id_dipendente
JOIN dipendenti d_new ON a.id_proprietario        = d_new.id_dipendente
ORDER BY s.data_modifica DESC;


SELECT
    ms.funzione_acn                                         AS Funzione,
    COUNT(*)                                                AS Misure_Con_Gap,
    SUM(CASE WHEN ga.priorita = 'Alta'  THEN 1 ELSE 0 END) AS Gap_Alta_Priorita,
    SUM(CASE WHEN ga.priorita = 'Media' THEN 1 ELSE 0 END) AS Gap_Media_Priorita,
    SUM(CASE WHEN ga.priorita = 'Bassa' THEN 1 ELSE 0 END) AS Gap_Bassa_Priorita,
    ROUND(AVG(pm_o.livello_maturita - pm_c.livello_maturita), 2) AS Delta_Medio,
    MIN(ga.scadenza)                                        AS Prossima_Scadenza
FROM gap_analisi ga
JOIN misura_sicurezza ms ON ga.id_misura          = ms.id_misura
JOIN profilo_misura pm_c ON pm_c.id_misura        = ga.id_misura
                         AND pm_c.id_profilo       = ga.id_profilo_corrente
JOIN profilo_misura pm_o ON pm_o.id_misura        = ga.id_misura
                         AND pm_o.id_profilo       = ga.id_profilo_obiettivo
WHERE pm_o.livello_maturita > pm_c.livello_maturita
GROUP BY ms.funzione_acn
ORDER BY Gap_Alta_Priorita DESC, Delta_Medio DESC;


SELECT
    ga.scadenza,
    ms.funzione_acn                                         AS Funzione,
    ms.codice                                               AS Codice_Misura,
    ms.nome                                                 AS Misura,
    pm_c.livello_maturita                                   AS Livello_Attuale,
    pm_o.livello_maturita                                   AS Livello_Target,
    (pm_o.livello_maturita - pm_c.livello_maturita)        AS Delta,
    ga.priorita,
    ga.piano_azione                                         AS Azione,
    CONCAT(d.nome, ' ', d.cognome)                          AS Responsabile,
    d.email                                                 AS Email_Responsabile,
    DATEDIFF(ga.scadenza, CURDATE())                        AS Giorni_Alla_Scadenza
FROM gap_analisi ga
JOIN misura_sicurezza ms ON ga.id_misura          = ms.id_misura
JOIN profilo_misura pm_c ON pm_c.id_misura        = ga.id_misura
                         AND pm_c.id_profilo       = ga.id_profilo_corrente
JOIN profilo_misura pm_o ON pm_o.id_misura        = ga.id_misura
                         AND pm_o.id_profilo       = ga.id_profilo_obiettivo
LEFT JOIN dipendenti d   ON ga.id_responsabile    = d.id_dipendente
WHERE pm_o.livello_maturita > pm_c.livello_maturita
ORDER BY ga.priorita DESC, ga.scadenza ASC;


SELECT
    pa.id_profilo,
    pa.tipo,
    pa.versione,
    pa.data_valutazione,
    CONCAT(d.nome, ' ', d.cognome)                          AS Responsabile,
    COUNT(pm.id_profilo_misura)                             AS Totale_Misure,
    SUM(CASE WHEN pm.stato = 'Conforme'        THEN 1 ELSE 0 END) AS Conformi,
    SUM(CASE WHEN pm.stato = 'Parziale'        THEN 1 ELSE 0 END) AS Parziali,
    SUM(CASE WHEN pm.stato = 'Non valutato'    THEN 1 ELSE 0 END) AS Non_Valutati,
    SUM(CASE WHEN pm.stato = 'Non applicabile' THEN 1 ELSE 0 END) AS Non_Applicabili,
    ROUND(
        100.0 * SUM(CASE WHEN pm.stato = 'Conforme' THEN 1 ELSE 0 END)
              / NULLIF(COUNT(pm.id_profilo_misura), 0), 1
    )                                                       AS Perc_Conformita,
    ROUND(AVG(pm.livello_maturita), 2)                      AS Maturita_Media
FROM profilo_acn pa
LEFT JOIN profilo_misura pm ON pa.id_profilo      = pm.id_profilo
LEFT JOIN dipendenti d      ON pa.id_responsabile = d.id_dipendente
GROUP BY pa.id_profilo, pa.tipo, pa.versione, pa.data_valutazione,
         d.nome, d.cognome
ORDER BY pa.data_valutazione DESC, pa.tipo;


SELECT
    a.nome_macchinario                          AS Asset,
    a.tipo_asset                                AS Tipo_Asset,
    a.ubicazione                                AS Ubicazione,
    v.codice_cve                                AS CVE,
    v.severita                                  AS Severita,
    v.cvss_score                                AS CVSS,
    v.descrizione                               AS Descrizione_Vulnerabilita,
    v.soluzione_consigliata                     AS Soluzione,
    ril.stato_remediation                       AS Stato,
    ril.data_scadenza_patch                     AS Scadenza_Patch,
    DATEDIFF(ril.data_scadenza_patch, CURDATE()) AS Giorni_Alla_Patch,
    CONCAT(d.nome, ' ', d.cognome)              AS Proprietario_Asset
FROM rilevazioni_sicurezza ril
JOIN asset          a ON ril.id_asset          = a.id_asset
JOIN vulnerabilita  v ON ril.id_vulnerabilita  = v.id_vulnerabilita
JOIN dipendenti     d ON a.id_proprietario     = d.id_dipendente
WHERE v.cvss_score >= 7.0
  AND ril.stato_remediation NOT IN ('Risolta', 'Rischio Accettato')
ORDER BY v.cvss_score DESC, ril.data_scadenza_patch ASC;


SELECT
    asm.id_assessment,
    asm.tipo_test                               AS Tipo_Test,
    asm.data_esecuzione                         AS Data,
    COALESCE(CONCAT(d.nome,' ',d.cognome), '–') AS Esecutore_Interno,
    COALESCE(f.nome_azienda, '–')               AS Fornitore_Esterno,
    COUNT(ril.id_rilevazione)                   AS Totale_Rilevazioni,
    SUM(CASE WHEN v.severita = 'Critica' THEN 1 ELSE 0 END) AS Critiche,
    SUM(CASE WHEN v.severita = 'Alta'    THEN 1 ELSE 0 END) AS Alte,
    SUM(CASE WHEN v.severita = 'Media'   THEN 1 ELSE 0 END) AS Medie,
    SUM(CASE WHEN v.severita = 'Bassa'   THEN 1 ELSE 0 END) AS Basse,
    SUM(CASE WHEN ril.stato_remediation = 'Risolta' THEN 1 ELSE 0 END) AS Risolte,
    asm.report_file_path                        AS Report
FROM assessment asm
LEFT JOIN dipendenti          d   ON asm.esecutore_interno_id  = d.id_dipendente
LEFT JOIN fornitori           f   ON asm.fornitore_esterno_id  = f.id_fornitore
LEFT JOIN rilevazioni_sicurezza ril ON asm.id_assessment       = ril.id_assessment
LEFT JOIN vulnerabilita       v   ON ril.id_vulnerabilita      = v.id_vulnerabilita
GROUP BY asm.id_assessment, asm.tipo_test, asm.data_esecuzione,
         d.nome, d.cognome, f.nome_azienda, asm.report_file_path
ORDER BY asm.data_esecuzione DESC;


SELECT
    a.nome_macchinario                          AS Asset,
    a.tipo_asset,
    s.nome_servizio                             AS Servizio_Critico,
    ms.codice                                   AS Codice_Misura,
    ms.funzione_acn                             AS Funzione,
    ms.nome                                     AS Misura,
    pm.stato                                    AS Stato_Conformita,
    pm.livello_maturita                         AS Maturita,
    pm.evidenze                                 AS Evidenze
FROM asset a
JOIN dipendenze_asset_servizio das ON a.id_asset      = das.id_asset
JOIN servizi                   s   ON das.id_servizio = s.id_servizio
                                   AND s.criticita_acn = 'Alta'
CROSS JOIN misura_sicurezza ms
LEFT JOIN profilo_misura pm ON ms.id_misura = pm.id_misura
LEFT JOIN profilo_acn    pa ON pm.id_profilo = pa.id_profilo
                            AND pa.tipo = 'corrente'
WHERE pm.stato IS NULL OR pm.stato != 'Conforme'
ORDER BY a.nome_macchinario, ms.funzione_acn, ms.codice;


SELECT
    f.nome_azienda                              AS Fornitore,
    f.livello_accesso                           AS Livello_Accesso,
    f.contatto_emergenza                        AS Contatto_Emergenza,
    COUNT(DISTINCT a.id_asset)                  AS Asset_Gestiti,
    COUNT(DISTINCT ril.id_rilevazione)          AS Vulnerabilita_Aperte,
    MAX(v.cvss_score)                           AS CVSS_Max,
    GROUP_CONCAT(DISTINCT v.codice_cve
                 ORDER BY v.cvss_score DESC
                 SEPARATOR ', ')                AS CVE_Aperte
FROM fornitori f
JOIN asset                  a   ON a.id_fornitore      = f.id_fornitore
LEFT JOIN rilevazioni_sicurezza ril ON ril.id_asset    = a.id_asset
                                    AND ril.stato_remediation
                                        NOT IN ('Risolta','Rischio Accettato')
LEFT JOIN vulnerabilita     v   ON ril.id_vulnerabilita = v.id_vulnerabilita
WHERE f.livello_accesso IS NOT NULL
GROUP BY f.id_fornitore, f.nome_azienda, f.livello_accesso, f.contatto_emergenza
ORDER BY Vulnerabilita_Aperte DESC, CVSS_Max DESC;


SELECT
    vga.codice_misura                           AS Codice,
    vga.funzione_acn                            AS Funzione,
    vga.nome_misura                             AS Misura,
    vga.livello_corrente                        AS Livello_AS_IS,
    vga.livello_obiettivo                       AS Livello_TO_BE,
    vga.delta_maturita                          AS Delta,
    vga.priorita,
    vga.piano_azione                            AS Azione_Correttiva,
    vga.scadenza,
    vga.responsabile,
    CASE
        WHEN vga.scadenza < CURDATE()                          THEN '🔴 SCADUTO'
        WHEN DATEDIFF(vga.scadenza, CURDATE()) <= 30           THEN '🟠 < 30 giorni'
        WHEN DATEDIFF(vga.scadenza, CURDATE()) <= 90           THEN '🟡 < 90 giorni'
        ELSE                                                        '🟢 In tempo'
    END                                         AS Semaforo_Scadenza
FROM vista_gap_analisi vga
ORDER BY
    FIELD(vga.priorita, 'Alta', 'Media', 'Bassa'),
    vga.scadenza ASC;


SELECT
    ms.funzione_acn                             AS Funzione,
    ms.codice                                   AS Codice_Misura,
    ms.nome                                     AS Misura,
    pa.versione                                 AS Versione_Profilo,
    pa.data_valutazione                         AS Data,
    pa.tipo                                     AS Tipo_Profilo,
    pm.stato                                    AS Stato,
    pm.livello_maturita                         AS Maturita,
    LAG(pm.livello_maturita)
        OVER (PARTITION BY ms.id_misura
              ORDER BY pa.data_valutazione)     AS Maturita_Precedente,
    pm.livello_maturita -
        COALESCE(LAG(pm.livello_maturita)
            OVER (PARTITION BY ms.id_misura
                  ORDER BY pa.data_valutazione), pm.livello_maturita)
                                                AS Variazione
FROM profilo_misura pm
JOIN misura_sicurezza ms ON pm.id_misura   = ms.id_misura
JOIN profilo_acn      pa ON pm.id_profilo  = pa.id_profilo
                         AND pa.tipo = 'corrente'
ORDER BY ms.funzione_acn, ms.codice, pa.data_valutazione;


SELECT
    d.id_dipendente,
    CONCAT(d.nome, ' ', d.cognome)              AS Dipendente,
    d.ruolo,
    d.email,
    COUNT(DISTINCT s.id_servizio)               AS Servizi_Presidiati,
    COUNT(DISTINCT a.id_asset)                  AS Asset_Posseduti,
    COUNT(DISTINCT pa.id_profilo)               AS Profili_ACN_Gestiti,
    COUNT(DISTINCT ga.id_gap)                   AS Gap_Assegnati,
    SUM(CASE WHEN ga.priorita = 'Alta' THEN 1 ELSE 0 END) AS Gap_Alta_Priorita,
    MIN(ga.scadenza)                            AS Prossima_Scadenza_Gap
FROM dipendenti d
LEFT JOIN servizi       s  ON s.id_responsabile  = d.id_dipendente
LEFT JOIN asset         a  ON a.id_proprietario  = d.id_dipendente
LEFT JOIN profilo_acn   pa ON pa.id_responsabile = d.id_dipendente
LEFT JOIN gap_analisi   ga ON ga.id_responsabile = d.id_dipendente
GROUP BY d.id_dipendente, d.nome, d.cognome, d.ruolo, d.email
HAVING Servizi_Presidiati > 0
    OR Asset_Posseduti > 0
    OR Profili_ACN_Gestiti > 0
    OR Gap_Assegnati > 0
ORDER BY Gap_Alta_Priorita DESC, Gap_Assegnati DESC;