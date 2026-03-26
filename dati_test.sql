-- Inserimento Dipendenti (Personale dell'azienda hardware)
INSERT INTO dipendenti (nome, cognome, ruolo, email) VALUES 
('Matteo', 'Visentini', 'CISO - Responsabile Sicurezza', 'm.visentini@hardware-factory.it'),
('Giulia', 'Bianchi', 'Responsabile Produzione CNC', 'g.bianchi@hardware-factory.it'),
('Luca', 'Rossi', 'Amministratore di Sistema', 'l.rossi@hardware-factory.it');

-- Inserimento Fornitori (Supply Chain)
INSERT INTO fornitori (nome_azienda, contatto_emergenza, livello_accesso) VALUES 
('Global Chip Services', '+39 02 998877', 'Accesso Remoto VPN'),
('Industrial Maintenance Srl', 'supporto@ind-maint.it', 'Accesso Fisico On-site');

-- Inserimento Servizi Critici (Processi Business)
INSERT INTO servizi (nome_servizio, criticita_acn, tempo_max_fermo_ore, id_responsabile) VALUES 
('Progettazione CAD Nuovi Processori', 'Alta', 2, 1),
('Linea di Assemblaggio Automatizzata', 'Media', 6, 2);

-- Inserimento Asset (Macchinari e Server)
INSERT INTO asset (nome_macchinario, tipo_asset, ubicazione, id_proprietario, id_fornitore) VALUES 
('Server Alpha-Pro CAD', 'Server Hardware', 'Data Center Piano 1', 3, 1),
('Macchina Taglio Laser CNC', 'Macchinario Industriale', 'Hangar Produzione A', 2, 2),
('Database IP Core', 'Software / Database', 'Cloud Privato', 1, NULL);

-- Inserimento Dipendenze (La ragnatela di relazioni)
INSERT INTO dipendenze_asset_servizio (id_asset, id_servizio, impatto_guasto) VALUES 
(1, 1, 'Bloccante'), -- Il Server Alpha serve per la Progettazione CAD
(3, 1, 'Bloccante'), -- Il Database IP serve per la Progettazione CAD
(2, 2, 'Bloccante'); -- La CNC serve per la Linea di Assemblaggio

-- Test del Versioning (Simuliamo un cambio di proprietario per attivare lo storico)
UPDATE asset SET id_proprietario = 1 WHERE nome_macchinario = 'Server Alpha-Pro CAD';