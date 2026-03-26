-- Pulizia iniziale (per permettere di rieseguire lo script)
DROP VIEW IF EXISTS report_conformita_acn;
DROP TABLE IF EXISTS storico_asset;
DROP TABLE IF EXISTS dipendenze_asset_servizio;
DROP TABLE IF EXISTS asset;
DROP TABLE IF EXISTS servizi;
DROP TABLE IF EXISTS fornitori;
DROP TABLE IF EXISTS dipendenti;

-- 1. Tabella DIPENDENTI (Responsabili e punti di contatto)
CREATE TABLE dipendenti (
    id_dipendente SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    ruolo VARCHAR(50) NOT NULL, -- es. CISO, Tecnico, Manager
    email VARCHAR(100) UNIQUE NOT NULL
);

-- 2. Tabella FORNITORI (Gestione Supply Chain NIS2)
CREATE TABLE fornitori (
    id_fornitore SERIAL PRIMARY KEY,
    nome_azienda VARCHAR(100) NOT NULL,
    contatto_emergenza VARCHAR(100),
    livello_accesso VARCHAR(50) -- es. Remoto VPN, Fisico
);

-- 3. Tabella SERVIZI (Processi aziendali critici)
CREATE TABLE servizi (
    id_servizio SERIAL PRIMARY KEY,
    nome_servizio VARCHAR(100) NOT NULL,
    criticita_acn VARCHAR(20) CHECK (criticita_acn IN ('Alta', 'Media', 'Bassa')),
    tempo_max_fermo_ore INT,
    id_responsabile INT REFERENCES dipendenti(id_dipendente) ON DELETE SET NULL
);

-- 4. Tabella ASSET (Hardware, Software e Risorse tecnologiche)
CREATE TABLE asset (
    id_asset SERIAL PRIMARY KEY,
    nome_macchinario VARCHAR(100) NOT NULL,
    tipo_asset VARCHAR(50), -- es. Server, CNC, Software CAD
    ubicazione VARCHAR(100),
    id_proprietario INT REFERENCES dipendenti(id_dipendente) ON DELETE SET NULL,
    id_fornitore INT REFERENCES fornitori(id_fornitore) ON DELETE SET NULL,
    data_ultimo_aggiornamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabella DIPENDENZE (Mappa delle relazioni Asset-Servizio)
CREATE TABLE dipendenze_asset_servizio (
    id_asset INT REFERENCES asset(id_asset) ON DELETE CASCADE,
    id_servizio INT REFERENCES servizi(id_servizio) ON DELETE CASCADE,
    impatto_guasto VARCHAR(50) DEFAULT 'Parziale',
    PRIMARY KEY (id_asset, id_servizio)
);

-- 6. Tabella STORICO_ASSET (Per il Versioning/Audit richiesto dal prof)
CREATE TABLE storico_asset (
    id_storico SERIAL PRIMARY KEY,
    id_asset INT,
    vecchio_proprietario_id INT,
    data_modifica TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nota_modifica TEXT
);

-- 7. TRIGGER: Gestione automatica dello storico (Versioning)
CREATE OR REPLACE FUNCTION func_registra_storico()
RETURNS TRIGGER AS $$
BEGIN
    -- Se cambia il proprietario dell'asset, salva il vecchio nello storico
    IF (OLD.id_proprietario IS DISTINCT FROM NEW.id_proprietario) THEN
        INSERT INTO storico_asset(id_asset, vecchio_proprietario_id, nota_modifica)
        VALUES (OLD.id_asset, OLD.id_proprietario, 'Variazione Asset Owner (Proprietario)');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_audit_asset
BEFORE UPDATE ON asset
FOR EACH ROW
EXECUTE FUNCTION func_registra_storico();

-- 8. VIEW: Generazione Report Strutturato per ACN (Output per Profilo NIS2)
CREATE VIEW report_conformita_acn AS
SELECT 
    s.nome_servizio AS "Servizio_Critico",
    s.criticita_acn AS "Classe_Critica_ACN",
    a.nome_macchinario AS "Asset_Tecnologico",
    a.tipo_asset AS "Categoria_Risorsa",
    (dip.nome || ' ' || dip.cognome) AS "Punto_Contatto_Responsabile",
    dip.email AS "Email_Referente",
    COALESCE(f.nome_azienda, 'Manutenzione Interna') AS "Supporto_Terze_Parti"
FROM servizi s
LEFT JOIN dipendenti dip ON s.id_responsabile = dip.id_dipendente
LEFT JOIN dipendenze_asset_servizio das ON s.id_servizio = das.id_servizio
LEFT JOIN asset a ON das.id_asset = a.id_asset
LEFT JOIN fornitori f ON a.id_fornitore = f.id_fornitore;