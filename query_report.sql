-- 1. Query: Elenco completo per il profilo ACN (Usa la View creata nello schema)
SELECT * FROM report_conformita_acn;

-- 2. Query: Elenco Asset Critici filtrati per alta criticità
SELECT 
    "Asset_Tecnologico", 
    "Categoria_Risorsa", 
    "Servizio_Critico"
FROM report_conformita_acn
WHERE "Classe_Critica_ACN" = 'Alta';

-- 3. Query: Verifica Dipendenze da Fornitori Terzi (Supply Chain)
SELECT 
    "Asset_Tecnologico", 
    "Supporto_Terze_Parti", 
    "Punto_Contatto_Responsabile"
FROM report_conformita_acn
WHERE "Supporto_Terze_Parti" != 'Manutenzione Interna';

-- 4. Query: Verifica dello storico delle modifiche (Audit Trail)
-- Mostra quando è cambiato un responsabile e chi era quello precedente
SELECT 
    s.data_modifica, 
    a.nome_macchinario, 
    d.cognome AS "Vecchio_Responsabile", 
    s.nota_modifica
FROM storico_asset s
JOIN asset a ON s.id_asset = a.id_asset
JOIN dipendenti d ON s.vecchio_proprietario_id = d.id_dipendente;

-- 5. Comando per generare l'output in formato CSV (da eseguire nel terminale PostgreSQL)
-- COPY (SELECT * FROM report_conformita_acn) 
-- TO 'C:\Users\Public\profilo_acn_output.csv' 
-- WITH (FORMAT CSV, HEADER, DELIMITER ',');