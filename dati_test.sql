-- Dipendenti (Personale dell'azienda)
INSERT INTO dipendenti (nome, cognome, ruolo, email) VALUES 
('Alessandro', 'Conti', 'CISO', 'alessandro.conti@electrocore.it'),
('Beatrice', 'Ricci', 'CEO', 'beatrice.ricci@electrocore.it'),
('Carlo', 'Marino', 'CTO', 'carlo.marino@electrocore.it'),
('Diana', 'Gallo', 'IT Manager', 'diana.gallo@electrocore.it'),
('Emanuele', 'Costa', 'Responsabile Produzione', 'emanuele.costa@electrocore.it'),
('Francesca', 'Giordano', 'Responsabile Supply Chain', 'francesca.giordano@electrocore.it'),
('Gabriele', 'Rizzo', 'SysAdmin', 'gabriele.rizzo@electrocore.it'),
('Ilaria', 'Lombardi', 'Specialista Cybersecurity', 'ilaria.lombardi@electrocore.it'),
('Lorenzo', 'Moretti', 'Tecnico di Rete', 'lorenzo.moretti@electrocore.it'),
('Martina', 'Barbieri', 'Ingegnere Elettronico', 'martina.barbieri@electrocore.it'),
('Nicola', 'Fontana', 'Ingegnere Elettronico', 'nicola.fontana@electrocore.it'),
('Paola', 'Santoro', 'Sviluppatore Firmware', 'paola.santoro@electrocore.it'),
('Riccardo', 'Mariani', 'Sviluppatore Firmware', 'riccardo.mariani@electrocore.it'),
('Silvia', 'Rinaldi', 'Responsabile Qualità', 'silvia.rinaldi@electrocore.it'),
('Tommaso', 'Ferrara', 'Tecnico Hardware', 'tommaso.ferrara@electrocore.it'),
('Valentina', 'Galli', 'Tecnico Hardware', 'valentina.galli@electrocore.it'),
('Andrea', 'Martini', 'Tecnico Manutenzione', 'andrea.martini@electrocore.it'),
('Elena', 'Leone', 'Tecnico Manutenzione', 'elena.leone@electrocore.it'),
('Marco', 'Longo', 'Operatore CNC', 'marco.longo@electrocore.it'),
('Chiara', 'Gentile', 'Operatore CNC', 'chiara.gentile@electrocore.it'),
('Roberto', 'Martinelli', 'Operatore Macchine SMT', 'roberto.martinelli@electrocore.it'),
('Giulia', 'Vitale', 'Operatore Macchine SMT', 'giulia.vitale@electrocore.it'),
('Stefano', 'Lombardo', 'Assemblatore Componenti', 'stefano.lombardo@electrocore.it'),
('Sara', 'Serra', 'Assemblatore Componenti', 'sara.serra@electrocore.it'),
('Luca', 'Coppola', 'Assemblatore Componenti', 'luca.coppola@electrocore.it'),
('Anna', 'De Santis', 'Collaudatore', 'anna.desantis@electrocore.it'),
('Matteo', 'D''Angelo', 'Collaudatore', 'matteo.dangelo@electrocore.it'),
('Marta', 'Marchetti', 'Analista Dati', 'marta.marchetti@electrocore.it'),
('Giovanni', 'Parisi', 'Responsabile Magazzino', 'giovanni.parisi@electrocore.it'),
('Elisa', 'Villa', 'Magazziniere', 'elisa.villa@electrocore.it'),
('Davide', 'Conte', 'Magazziniere', 'davide.conte@electrocore.it'),
('Giorgia', 'Ferraro', 'Responsabile HR', 'giorgia.ferraro@electrocore.it'),
('Simone', 'De Angelis', 'Impiegato Amministrativo', 'simone.deangelis@electrocore.it'),
('Alice', 'Bianchi', 'Responsabile Acquisti', 'alice.bianchi@electrocore.it'),
('Fabio', 'Rossi', 'Buyer', 'fabio.rossi@electrocore.it'),
('Letizia', 'Russo', 'Help Desk IT', 'letizia.russo@electrocore.it'),
('Antonio', 'Ferrari', 'Help Desk IT', 'antonio.ferrari@electrocore.it'),
('Serena', 'Esposito', 'Progettista CAD', 'serena.esposito@electrocore.it'),
('Paolo', 'Romano', 'Progettista CAD', 'paolo.romano@electrocore.it'),
('Veronica', 'Colombo', 'Responsabile Conformità', 'veronica.colombo@electrocore.it');

-- Fornitori (Supply Chain)
INSERT INTO fornitori (nome_azienda, contatto_emergenza, livello_accesso) VALUES 
('Silicon Valley Materials', '+1-555-0101', 'Nessun Accesso'),
('EuroLogistics SpA', 'emergenze@eurologistics.it', 'Fisico Limitato (Magazzino)'),
('SecureNet Solutions', '+39 02 9988776', 'Remoto VPN (Privilegiato)'),
('TechMachinery GmbH', 'support@techmachinery.de', 'Remoto VPN (Supervisionato)'),
('Global SMT Corp', '+44 20 7946 0958', 'Remoto VPN'),
('Alpha Cooling Systems', '+39 06 1122334', 'Fisico (Sale Server)'),
('CloudData Enterprise', 'noc@clouddata.com', 'Cloud API / Remoto'),
('MicroChip Supplies', '+886 2 2345 6789', 'Nessun Accesso'),
('CyberGuard IT', '+39 02 4455667', 'Remoto VPN (Privilegiato)'),
('PowerGrid Italia', 'guasti@powergrid.it', 'Fisico Esterno'),
('ErpSoft Dynamics', 'support@erpsoft.com', 'Remoto VPN (Applicativo)'),
('MetalWorks Srl', '+39 045 123456', 'Nessun Accesso'),
('SecureAccess Control', '+39 02 8877665', 'Fisico e Remoto'),
('CleanRoom Services', 'interventi@cleanroom.it', 'Fisico Completo'),
('FastDelivery Express', '+39 06 9988776', 'Fisico Limitato (Magazzino)'),
('NextGen CAD', 'support@nextgencad.com', 'Remoto Standard'),
('Optical Sensors Inc.', '+1-555-0202', 'Nessun Accesso'),
('Network Infrastructure Co.', '+39 011 223344', 'Remoto VPN (Privilegiato)'),
('Waste Management Eco', 'ritiri@wasteeco.it', 'Fisico Esterno'),
('PCB Solutions', 'urgent@pcbsolutions.tw', 'Nessun Accesso'),
('FireProtection Srl', '+39 06 5544332', 'Fisico Completo'),
('QualityTest Labs', 'reports@qualitytest.it', 'Remoto Standard'),
('Packaging Pro', '+39 051 7766554', 'Nessun Accesso'),
('Backup Cloud Services', 'soc@backupservices.com', 'Cloud API / Remoto'),
('SmartFactory Integrators', '+39 02 3344556', 'Remoto e Fisico');

-- Servizi Critici
INSERT INTO servizi (nome_servizio, criticita_acn, tempo_max_fermo_ore, id_responsabile) VALUES 
('Linea Produzione Schede Madri (SMT)', 'Alta', 2, 5),
('Sistema Controllo Qualità Ottica (AOI)', 'Alta', 4, 14),
('Infrastruttura Server SAP/ERP', 'Alta', 4, 4),
('Sviluppo e Compilazione Firmware', 'Media', 12, 12),
('Gestione Magazzino Automatizzato', 'Alta', 6, 29),
('Progettazione Circuitale CAD', 'Media', 24, 38),
('Sistema di Monitoraggio SOC/Cybersecurity', 'Alta', 1, 1),
('Servizio Posta Elettronica Aziendale', 'Media', 8, 7),
('Backup e Disaster Recovery Cloud', 'Alta', 2, 8),
('Gestione Identità e Accessi (Active Directory)', 'Alta', 1, 4),
('Controllo Numerico CNC (Meccanica)', 'Media', 12, 19),
('Sistema Test di Burn-in Componenti', 'Alta', 6, 26),
('Piattaforma E-commerce B2B', 'Media', 8, 34),
('Gestione Documentale Normative ISO', 'Bassa', 48, 40),
('Sistema Controllo Accessi Fisici (Badge)', 'Alta', 4, 13),
('Monitoraggio Ambientale Camera Bianca', 'Alta', 2, 10),
('Servizio Telefonia VoIP e Centralino', 'Bassa', 24, 36),
('Gestione Logistica Spedizioni', 'Media', 8, 6),
('Repository Codice Sorgente (GitLab)', 'Alta', 4, 3),
('Sistema Paghe e Amministrazione', 'Bassa', 72, 33),
('Manutenzione Predittiva IoT', 'Media', 24, 17),
('Portale Web Fornitori', 'Media', 12, 35),
('Sistema di Videosorveglianza IP', 'Media', 6, 1),
('Laboratorio Ricerca e Sviluppo (R&D)', 'Bassa', 48, 11),
('Infrastruttura Wi-Fi Industriale', 'Media', 4, 9);

-- Asset (Macchinari e Server)
INSERT INTO asset (nome_macchinario, tipo_asset, ubicazione, id_proprietario, id_fornitore) VALUES 
-- INFRASTRUTTURA IT (Server e Networking)
('Server Cluster Proxmox 01', 'Server Fisico', 'Data Center Piano Terra', 4, 7),
('Server Cluster Proxmox 02', 'Server Fisico', 'Data Center Piano Terra', 4, 7),
('Storage NAS TrueNAS Enterprise', 'Storage', 'Data Center Piano Terra', 7, 24),
('Firewall FortiGate 200F', 'Network Appliance', 'Locale Rack Ingresso', 1, 3),
('Core Switch Cisco Nexus', 'Network Appliance', 'Data Center Piano Terra', 9, 18),
('Unità Backup LTO-9', 'Storage', 'Caveau Interrato', 8, 24),
('UPS Schneider Electric 10kVA', 'Power', 'Locale Tecnico A', 17, 10),

-- AREA PRODUZIONE SMT (Macchinari Industriali)
('Pick and Place Yamaha YSM20R', 'Macchina SMT', 'Linea Produzione 1', 5, 5),
('Fornu di Rifusione Heller 1913', 'Forno Industriale', 'Linea Produzione 1', 5, 4),
('Stampatrice Serigrafica DEK NeoHorizon', 'Stampatrice', 'Linea Produzione 1', 19, 5),
('Ispezione Ottica AOI Omron', 'Sistema Ispezione', 'Linea Produzione 1', 14, 22),
('Braccio Robotico KUKA KR6', 'Robotica', 'Area Assemblaggio', 18, 4),
('Macchina CNC Haas VF-2', 'CNC', 'Officina Meccanica', 19, 4),
('Saldatrice ad Onda Ersa Powerflow', 'Saldatrice', 'Linea Produzione 2', 21, 14),
('Sistema Raggi X per PCB', 'Sistema Ispezione', 'Laboratorio Qualità', 14, 22),

-- AREA PROGETTAZIONE E R&D
('Workstation CAD 01 - Lead Designer', 'Workstation', 'Ufficio R&D', 38, 16),
('Workstation CAD 02', 'Workstation', 'Ufficio R&D', 39, 16),
('Oscilloscopio Digitale Tektronix', 'Strumento Misura', 'Laboratorio R&D', 10, 17),
('Analizzatore di Spettro Keysight', 'Strumento Misura', 'Laboratorio R&D', 11, 17),
('Stampante 3D Prototipazione', 'Stampante 3D', 'Ufficio R&D', 38, 25),

-- ASSET DI SICUREZZA FISICA E SERVIZI GENERALI
('NVR Videosorveglianza 64ch', 'Server Video', 'Locale Portineria', 1, 13),
('Controller Varchi Biometrici', 'Controllo Accessi', 'Ingresso Principale', 13, 13),
('Sensore Particellare Camera Bianca', 'Sensore IoT', 'Camera Bianca', 10, 14),
('Centrale Antincendio Notifier', 'Sicurezza', 'Locale Tecnico B', 1, 21),
('Condizionatore Precisione Emerson', 'HVAC', 'Data Center Piano Terra', 17, 6),

-- ALTRI ASSET OPERATIVI
('Terminale Logistica Zebra 01', 'Palmare', 'Magazzino', 29, 2),
('Terminale Logistica Zebra 02', 'Palmare', 'Magazzino', 30, 2),
('Server Gestionale ERP (Virtuale)', 'VM', 'Cluster 01', 4, 11),
('Gateway IoT Produzione', 'Gateway', 'Linea Produzione 1', 7, 25),
('Licenza Altium Designer Multi-user', 'Software', 'Server Licenze', 3, 16),
('Plotter Etichettatura Industriale', 'Stampante', 'Magazzino', 31, 15),
('Drone Ispezione Tetti/Impianti', 'Drone', 'Ufficio Manutenzione', 18, 25),
('Workstation Controllo CNC', 'PC Industriale', 'Officina Meccanica', 20, 4),
('Tablet Supervisore Produzione', 'Tablet', 'Area Produzione', 5, 3),
('Server Proxy/Web Filter', 'VM', 'Cluster 02', 1, 9),
('Router Fibra Aziendale', 'Network Appliance', 'Locale Rack Ingresso', 9, 18),
('Sistema Test Funzionale ICT', 'Tester', 'Linea Produzione 2', 27, 22),
('Microscopio Elettronico', 'Strumento Misura', 'Laboratorio Qualità', 14, 17),
('Server Database SQL', 'VM', 'Cluster 01', 4, 11),
('Stazione Saldatura Manuale JBC', 'Saldatrice', 'Area Rilavorazioni', 23, 14);

-- Inserimento Dipendenze (La ragnatela di relazioni)
INSERT INTO dipendenze_asset_servizio (id_asset, id_servizio, impatto_guasto) VALUES 
-- SERVIZIO: Linea Produzione Schede Madri (ID_SERVIZIO: 1)
(8, 1, 'Bloccante'),  -- Pick and Place
(9, 1, 'Bloccante'),  -- Forno Rifusione
(10, 1, 'Bloccante'), -- Stampatrice
(29, 1, 'Degradazione'), -- Gateway IoT

-- SERVIZIO: Infrastruttura Server SAP/ERP (ID_SERVIZIO: 3)
(1, 3, 'Bloccante'),  -- Cluster Proxmox 01
(3, 3, 'Bloccante'),  -- Storage NAS
(39, 3, 'Bloccante'), -- Server Database SQL
(28, 3, 'Bloccante'), -- Server Gestionale ERP

-- SERVIZIO: Sistema Monitoraggio SOC (ID_SERVIZIO: 7)
(4, 7, 'Bloccante'),  -- Firewall
(5, 7, 'Degradazione'), -- Core Switch
(35, 7, 'Degradazione'), -- Server Proxy

-- SERVIZIO: Backup e Disaster Recovery (ID_SERVIZIO: 9)
(6, 9, 'Bloccante'),  -- Unità LTO-9
(3, 9, 'Degradazione'), -- Storage NAS

-- SERVIZIO: Gestione Magazzino (ID_SERVIZIO: 5)
(26, 5, 'Bloccante'), -- Terminale Zebra 01
(27, 5, 'Degradazione'), -- Terminale Zebra 02
(31, 5, 'Trascurabile'), -- Plotter Etichette

-- SERVIZIO: Progettazione CAD (ID_SERVIZIO: 6)
(16, 6, 'Bloccante'), -- Workstation 01
(17, 6, 'Degradazione'), -- Workstation 02
(30, 6, 'Bloccante'), -- Licenza Altium

-- SERVIZIO: Controllo Accessi Fisici (ID_SERVIZIO: 15)
(22, 15, 'Bloccante'), -- Controller Varchi
(1, 15, 'Degradazione'), -- Serve Cluster (per il database accessi)

-- SERVIZIO: Monitoraggio Camera Bianca (ID_SERVIZIO: 16)
(23, 16, 'Bloccante'), -- Sensore Particellare
(25, 16, 'Bloccante'), -- Condizionatore Precisione

-- SERVIZIO: Qualità e AOI (ID_SERVIZIO: 2)
(11, 2, 'Bloccante'), -- Ispezione AOI
(15, 2, 'Degradazione'), -- Raggi X PCB
(38, 2, 'Trascurabile'), -- Microscopio Elettronico

-- DIPENDENZE TRASVERSALI (Power e Rete)
(7, 1, 'Bloccante'),  -- UPS su Linea Produzione
(7, 3, 'Bloccante'),  -- UPS su ERP
(36, 7, 'Bloccante'), -- Router Fibra su SOC
(5, 6, 'Degradazione'); -- Core Switch su Ufficio R&D

-- Test del Versioning (Simuliamo un cambio di proprietario per attivare lo storico)
UPDATE asset SET id_proprietario = 1 WHERE nome_macchinario = 'Server Alpha-Pro CAD';