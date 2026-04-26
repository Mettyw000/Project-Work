SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `assessment` (
  `id_assessment` bigint(20) UNSIGNED NOT NULL,
  `tipo_test` varchar(50) DEFAULT NULL CHECK (`tipo_test` in ('Vulnerability Assessment','Penetration Test','Code Review')),
  `data_esecuzione` date NOT NULL,
  `esecutore_interno_id` bigint(20) UNSIGNED DEFAULT NULL,
  `fornitore_esterno_id` bigint(20) UNSIGNED DEFAULT NULL,
  `report_file_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `assessment` (`id_assessment`, `tipo_test`, `data_esecuzione`, `esecutore_interno_id`, `fornitore_esterno_id`, `report_file_path`) VALUES
(1, 'Vulnerability Assessment', '2024-01-15', 2, 2, '/reports/2024/va_mensile_gennaio.pdf'),
(2, 'Penetration Test', '2024-02-10', 1, 1, '/reports/2024/pentest_perimetro_esterno.pdf'),
(3, 'Code Review', '2024-02-28', 3, 12, '/reports/2024/analisi_codice_app_mobile.pdf'),
(4, 'Vulnerability Assessment', '2024-03-15', 2, 7, '/reports/2024/va_infrastruttura_server.pdf'),
(5, 'Vulnerability Assessment', '2024-04-12', 2, 13, '/reports/2024/scansione_rete_guest.pdf'),
(6, 'Penetration Test', '2024-05-05', 1, 3, '/reports/2024/red_team_esercizio_maggio.pdf'),
(7, 'Code Review', '2024-05-20', 3, 11, '/reports/2024/audit_sito_web_istituzionale.pdf'),
(8, 'Vulnerability Assessment', '2024-06-15', 2, 4, '/reports/2024/va_mensile_giugno.pdf'),
(9, 'Vulnerability Assessment', '2024-07-10', 4, 6, '/reports/2024/scansione_apparati_ot.pdf'),
(10, 'Penetration Test', '2024-08-01', 1, 2, '/reports/2024/verifiche_compliance_nis2.pdf'),
(11, 'Code Review', '2024-09-12', 3, 11, '/reports/2024/revisione_script_automazione.pdf'),
(12, 'Vulnerability Assessment', '2024-10-15', 2, 5, '/reports/2024/va_mensile_ottobre.pdf'),
(13, 'Penetration Test', '2024-11-05', 1, 1, '/reports/2024/test_sicurezza_wi-fi.pdf'),
(14, 'Vulnerability Assessment', '2024-12-01', 4, 9, '/reports/2024/va_fine_anno_asset_critici.pdf'),
(15, 'Code Review', '2024-12-20', 3, 3, '/reports/2024/analisi_sicurezza_api_cloud.pdf');


CREATE TABLE `asset` (
  `id_asset` bigint(20) UNSIGNED NOT NULL,
  `nome_macchinario` varchar(100) NOT NULL,
  `tipo_asset` varchar(50) DEFAULT NULL,
  `ubicazione` varchar(100) DEFAULT NULL,
  `id_proprietario` bigint(20) UNSIGNED DEFAULT NULL,
  `id_fornitore` bigint(20) UNSIGNED DEFAULT NULL,
  `data_ultimo_aggiornamento` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `asset` (`id_asset`, `nome_macchinario`, `tipo_asset`, `ubicazione`, `id_proprietario`, `id_fornitore`, `data_ultimo_aggiornamento`) VALUES
(1, 'Server Cluster Proxmox 01', 'Server Fisico', 'Data Center Piano Terra', 4, 7, '2026-04-08 15:54:14'),
(2, 'Server Cluster Proxmox 02', 'Server Fisico', 'Data Center Piano Terra', 4, 7, '2026-04-08 15:54:14'),
(3, 'Storage NAS TrueNAS Enterprise', 'Storage', 'Data Center Piano Terra', 7, 24, '2026-04-08 15:54:14'),
(4, 'Firewall FortiGate 200F', 'Network Appliance', 'Locale Rack Ingresso', 1, 3, '2026-04-08 15:54:14'),
(5, 'Core Switch Cisco Nexus', 'Network Appliance', 'Data Center Piano Terra', 9, 18, '2026-04-08 15:54:14'),
(6, 'Unità Backup LTO-9', 'Storage', 'Caveau Interrato', 8, 24, '2026-04-08 15:54:14'),
(7, 'UPS Schneider Electric 10kVA', 'Power', 'Locale Tecnico A', 17, 10, '2026-04-08 15:54:14'),
(8, 'Pick and Place Yamaha YSM20R', 'Macchina SMT', 'Linea Produzione 1', 5, 5, '2026-04-08 15:54:14'),
(9, 'Forno di Rifusione Heller 1913', 'Forno Industriale', 'Linea Produzione 1', 5, 4, '2026-04-08 15:54:14'),
(10, 'Stampatrice Serigrafica DEK NeoHorizon', 'Stampatrice', 'Linea Produzione 1', 19, 5, '2026-04-08 15:54:14'),
(11, 'Ispezione Ottica AOI Omron', 'Sistema Ispezione', 'Linea Produzione 1', 14, 22, '2026-04-08 15:54:14'),
(12, 'Braccio Robotico KUKA KR6', 'Robotica', 'Area Assemblaggio', 18, 4, '2026-04-08 15:54:14'),
(13, 'Macchina CNC Haas VF-2', 'CNC', 'Officina Meccanica', 19, 4, '2026-04-08 15:54:14'),
(14, 'Saldatrice ad Onda Ersa Powerflow', 'Saldatrice', 'Linea Produzione 2', 21, 14, '2026-04-08 15:54:14'),
(15, 'Sistema Raggi X per PCB', 'Sistema Ispezione', 'Laboratorio Qualità', 14, 22, '2026-04-08 15:54:14'),
(16, 'Workstation CAD 01 - Lead Designer', 'Workstation', 'Ufficio R&D', 38, 16, '2026-04-08 15:54:14'),
(17, 'Workstation CAD 02', 'Workstation', 'Ufficio R&D', 39, 16, '2026-04-08 15:54:14'),
(18, 'Oscilloscopio Digitale Tektronix', 'Strumento Misura', 'Laboratorio R&D', 10, 17, '2026-04-08 15:54:14'),
(19, 'Analizzatore di Spettro Keysight', 'Strumento Misura', 'Laboratorio R&D', 11, 17, '2026-04-08 15:54:14'),
(20, 'Stampante 3D Prototipazione', 'Stampante 3D', 'Ufficio R&D', 38, 25, '2026-04-08 15:54:14'),
(21, 'NVR Videosorveglianza 64ch', 'Server Video', 'Locale Portineria', 1, 13, '2026-04-08 15:54:14'),
(22, 'Controller Varchi Biometrici', 'Controllo Accessi', 'Ingresso Principale', 13, 13, '2026-04-08 15:54:14'),
(23, 'Sensore Particellare Camera Bianca', 'Sensore IoT', 'Camera Bianca', 10, 14, '2026-04-08 15:54:14'),
(24, 'Centrale Antincendio Notifier', 'Sicurezza', 'Locale Tecnico B', 1, 21, '2026-04-08 15:54:14'),
(25, 'Condizionatore Precisione Emerson', 'HVAC', 'Data Center Piano Terra', 17, 6, '2026-04-08 15:54:14'),
(26, 'Terminale Logistica Zebra 01', 'Palmare', 'Magazzino', 29, 2, '2026-04-08 15:54:14'),
(27, 'Terminale Logistica Zebra 02', 'Palmare', 'Magazzino', 30, 2, '2026-04-08 15:54:14'),
(28, 'Server Gestionale ERP (Virtuale)', 'VM', 'Cluster 01', 4, 11, '2026-04-08 15:54:14'),
(29, 'Gateway IoT Produzione', 'Gateway', 'Linea Produzione 1', 7, 25, '2026-04-08 15:54:14'),
(30, 'Licenza Altium Designer Multi-user', 'Software', 'Server Licenze', 3, 16, '2026-04-08 15:54:14'),
(31, 'Plotter Etichettatura Industriale', 'Stampante', 'Magazzino', 31, 15, '2026-04-08 15:54:14'),
(32, 'Drone Ispezione Tetti/Impianti', 'Drone', 'Ufficio Manutenzione', 18, 25, '2026-04-08 15:54:14'),
(33, 'Workstation Controllo CNC', 'PC Industriale', 'Officina Meccanica', 20, 4, '2026-04-08 15:54:14'),
(34, 'Tablet Supervisore Produzione', 'Tablet', 'Area Produzione', 5, 3, '2026-04-08 15:54:14'),
(35, 'Server Proxy/Web Filter', 'VM', 'Cluster 02', 1, 9, '2026-04-08 15:54:14'),
(36, 'Router Fibra Aziendale', 'Network Appliance', 'Locale Rack Ingresso', 9, 18, '2026-04-08 15:54:14'),
(37, 'Sistema Test Funzionale ICT', 'Tester', 'Linea Produzione 2', 27, 22, '2026-04-08 15:54:14'),
(38, 'Microscopio Elettronico', 'Strumento Misura', 'Laboratorio Qualità', 14, 17, '2026-04-08 15:54:14'),
(39, 'Server Database SQL', 'VM', 'Cluster 01', 4, 11, '2026-04-08 15:54:14'),
(40, 'Stazione Saldatura Manuale JBC', 'Saldatrice', 'Area Rilavorazioni', 23, 14, '2026-04-08 15:54:14');


CREATE TABLE `dipendenti` (
  `id_dipendente` bigint(20) UNSIGNED NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `ruolo` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `dipendenti` (`id_dipendente`, `nome`, `cognome`, `ruolo`, `email`) VALUES
(1, 'Alessandro', 'Conti', 'CISO', 'alessandro.conti@electrocore.it'),
(2, 'Beatrice', 'Ricci', 'CEO', 'beatrice.ricci@electrocore.it'),
(3, 'Carlo', 'Marino', 'CTO', 'carlo.marino@electrocore.it'),
(4, 'Diana', 'Gallo', 'IT Manager', 'diana.gallo@electrocore.it'),
(5, 'Emanuele', 'Costa', 'Responsabile Produzione', 'emanuele.costa@electrocore.it'),
(6, 'Francesca', 'Giordano', 'Responsabile Supply Chain', 'francesca.giordano@electrocore.it'),
(7, 'Gabriele', 'Rizzo', 'SysAdmin', 'gabriele.rizzo@electrocore.it'),
(8, 'Ilaria', 'Lombardi', 'Specialista Cybersecurity', 'ilaria.lombardi@electrocore.it'),
(9, 'Lorenzo', 'Moretti', 'Tecnico di Rete', 'lorenzo.moretti@electrocore.it'),
(10, 'Martina', 'Barbieri', 'Ingegnere Elettronico', 'martina.barbieri@electrocore.it'),
(11, 'Nicola', 'Fontana', 'Ingegnere Elettronico', 'nicola.fontana@electrocore.it'),
(12, 'Paola', 'Santoro', 'Sviluppatore Firmware', 'paola.santoro@electrocore.it'),
(13, 'Riccardo', 'Mariani', 'Sviluppatore Firmware', 'riccardo.mariani@electrocore.it'),
(14, 'Silvia', 'Rinaldi', 'Responsabile Qualità', 'silvia.rinaldi@electrocore.it'),
(15, 'Tommaso', 'Ferrara', 'Tecnico Hardware', 'tommaso.ferrara@electrocore.it'),
(16, 'Valentina', 'Galli', 'Tecnico Hardware', 'valentina.galli@electrocore.it'),
(17, 'Andrea', 'Martini', 'Tecnico Manutenzione', 'andrea.martini@electrocore.it'),
(18, 'Elena', 'Leone', 'Tecnico Manutenzione', 'elena.leone@electrocore.it'),
(19, 'Marco', 'Longo', 'Operatore CNC', 'marco.longo@electrocore.it'),
(20, 'Chiara', 'Gentile', 'Operatore CNC', 'chiara.gentile@electrocore.it'),
(21, 'Roberto', 'Martinelli', 'Operatore Macchine SMT', 'roberto.martinelli@electrocore.it'),
(22, 'Giulia', 'Vitale', 'Operatore Macchine SMT', 'giulia.vitale@electrocore.it'),
(23, 'Stefano', 'Lombardo', 'Assemblatore Componenti', 'stefano.lombardo@electrocore.it'),
(24, 'Sara', 'Serra', 'Assemblatore Componenti', 'sara.serra@electrocore.it'),
(25, 'Luca', 'Coppola', 'Assemblatore Componenti', 'luca.coppola@electrocore.it'),
(26, 'Anna', 'De Santis', 'Collaudatore', 'anna.desantis@electrocore.it'),
(27, 'Matteo', 'Angelo', 'Collaudatore', 'matteo.dangelo@electrocore.it'),
(28, 'Marta', 'Marchetti', 'Analista Dati', 'marta.marchetti@electrocore.it'),
(29, 'Giovanni', 'Parisi', 'Responsabile Magazzino', 'giovanni.parisi@electrocore.it'),
(30, 'Elisa', 'Villa', 'Magazziniere', 'elisa.villa@electrocore.it'),
(31, 'Davide', 'Conte', 'Magazziniere', 'davide.conte@electrocore.it'),
(32, 'Giorgia', 'Ferraro', 'Responsabile HR', 'giorgia.ferraro@electrocore.it'),
(33, 'Simone', 'De Angelis', 'Impiegato Amministrativo', 'simone.deangelis@electrocore.it'),
(34, 'Alice', 'Bianchi', 'Responsabile Acquisti', 'alice.bianchi@electrocore.it'),
(35, 'Fabio', 'Rossi', 'Buyer', 'fabio.rossi@electrocore.it'),
(36, 'Letizia', 'Russo', 'Help Desk IT', 'letizia.russo@electrocore.it'),
(37, 'Antonio', 'Ferrari', 'Help Desk IT', 'antonio.ferrari@electrocore.it'),
(38, 'Serena', 'Esposito', 'Progettista CAD', 'serena.esposito@electrocore.it'),
(39, 'Paolo', 'Romano', 'Progettista CAD', 'paolo.romano@electrocore.it'),
(40, 'Veronica', 'Colombo', 'Responsabile Conformità', 'veronica.colombo@electrocore.it');


CREATE TABLE `dipendenze_asset_servizio` (
  `id_asset` bigint(20) UNSIGNED NOT NULL,
  `id_servizio` bigint(20) UNSIGNED NOT NULL,
  `impatto_guasto` varchar(50) DEFAULT 'Parziale'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `dipendenze_asset_servizio` (`id_asset`, `id_servizio`, `impatto_guasto`) VALUES
(1, 3, 'Bloccante'),
(1, 15, 'Degradazione'),
(3, 3, 'Bloccante'),
(3, 9, 'Degradazione'),
(4, 7, 'Bloccante'),
(5, 6, 'Degradazione'),
(5, 7, 'Degradazione'),
(6, 9, 'Bloccante'),
(7, 1, 'Bloccante'),
(7, 3, 'Bloccante'),
(8, 1, 'Bloccante'),
(9, 1, 'Bloccante'),
(10, 1, 'Bloccante'),
(11, 2, 'Bloccante'),
(15, 2, 'Degradazione'),
(16, 6, 'Bloccante'),
(17, 6, 'Degradazione'),
(22, 15, 'Bloccante'),
(23, 16, 'Bloccante'),
(25, 16, 'Bloccante'),
(26, 5, 'Bloccante'),
(27, 5, 'Degradazione'),
(28, 3, 'Bloccante'),
(29, 1, 'Degradazione'),
(30, 6, 'Bloccante'),
(31, 5, 'Trascurabile'),
(35, 7, 'Degradazione'),
(36, 7, 'Bloccante'),
(38, 2, 'Trascurabile'),
(39, 3, 'Bloccante');


CREATE TABLE `fornitori` (
  `id_fornitore` bigint(20) UNSIGNED NOT NULL,
  `nome_azienda` varchar(100) NOT NULL,
  `contatto_emergenza` varchar(100) DEFAULT NULL,
  `livello_accesso` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `fornitori` (`id_fornitore`, `nome_azienda`, `contatto_emergenza`, `livello_accesso`) VALUES
(1, 'Silicon Valley Materials', '+1-555-0101', 'Nessun Accesso'),
(2, 'EuroLogistics SpA', 'emergenze@eurologistics.it', 'Fisico Limitato (Magazzino)'),
(3, 'SecureNet Solutions', '+39 02 9988776', 'Remoto VPN (Privilegiato)'),
(4, 'TechMachinery GmbH', 'support@techmachinery.de', 'Remoto VPN (Supervisionato)'),
(5, 'Global SMT Corp', '+44 20 7946 0958', 'Remoto VPN'),
(6, 'Alpha Cooling Systems', '+39 06 1122334', 'Fisico (Sale Server)'),
(7, 'CloudData Enterprise', 'noc@clouddata.com', 'Cloud API / Remoto'),
(8, 'MicroChip Supplies', '+886 2 2345 6789', 'Nessun Accesso'),
(9, 'CyberGuard IT', '+39 02 4455667', 'Remoto VPN (Privilegiato)'),
(10, 'PowerGrid Italia', 'guasti@powergrid.it', 'Fisico Esterno'),
(11, 'ErpSoft Dynamics', 'support@erpsoft.com', 'Remoto VPN (Applicativo)'),
(12, 'MetalWorks Srl', '+39 045 123456', 'Nessun Accesso'),
(13, 'SecureAccess Control', '+39 02 8877665', 'Fisico e Remoto'),
(14, 'CleanRoom Services', 'interventi@cleanroom.it', 'Fisico Completo'),
(15, 'FastDelivery Express', '+39 06 9988776', 'Fisico Limitato (Magazzino)'),
(16, 'NextGen CAD', 'support@nextgencad.com', 'Remoto Standard'),
(17, 'Optical Sensors Inc.', '+1-555-0202', 'Nessun Accesso'),
(18, 'Network Infrastructure Co.', '+39 011 223344', 'Remoto VPN (Privilegiato)'),
(19, 'Waste Management Eco', 'ritiri@wasteeco.it', 'Fisico Esterno'),
(20, 'PCB Solutions', 'urgent@pcbsolutions.tw', 'Nessun Accesso'),
(21, 'FireProtection Srl', '+39 06 5544332', 'Fisico Completo'),
(22, 'QualityTest Labs', 'reports@qualitytest.it', 'Remoto Standard'),
(23, 'Packaging Pro', '+39 051 7766554', 'Nessun Accesso'),
(24, 'Backup Cloud Services', 'soc@backupservices.com', 'Cloud API / Remoto'),
(25, 'SmartFactory Integrators', '+39 02 3344556', 'Remoto e Fisico');


CREATE TABLE `gap_analisi` (
  `id_gap` bigint(20) UNSIGNED NOT NULL,
  `id_misura` bigint(20) UNSIGNED NOT NULL,
  `id_profilo_corrente` bigint(20) UNSIGNED NOT NULL,
  `id_profilo_obiettivo` bigint(20) UNSIGNED NOT NULL,
  `priorita` varchar(10) DEFAULT 'Media' CHECK (`priorita` in ('Alta','Media','Bassa')),
  `piano_azione` text DEFAULT NULL,
  `scadenza` date DEFAULT NULL,
  `id_responsabile` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `gap_analisi` (`id_gap`, `id_misura`, `id_profilo_corrente`, `id_profilo_obiettivo`, `priorita`, `piano_azione`, `scadenza`, `id_responsabile`) VALUES
(1, 2, 1, 2, 'Alta', 'Redigere una strategia formale di gestione del rischio cyber. Includere soglie di tolleranza, KRI e integrazione con il risk management aziendale.', '2024-06-30', 1),
(2, 6, 1, 2, 'Alta', 'Avviare un programma di vendor risk assessment: questionari di sicurezza, audit on-site per fornitori critici, clausole contrattuali NIS2-compliant.', '2024-09-30', 6),
(3, 4, 1, 2, 'Media', 'Estendere l inventario software alle workstation OT tramite agent di discovery. Automatizzare il processo con integrazione CMDB.', '2024-07-31', 4),
(4, 5, 1, 2, 'Alta', 'Includere i sistemi OT nel piano di vulnerability assessment. Definire finestre di manutenzione per scansioni non invasive sui macchinari.', '2024-08-31', 8),
(5, 8, 1, 2, 'Media', 'Sviluppare un piano di formazione annuale sulla cybersecurity differenziato per ruolo. Includere esercitazioni di phishing simulato.', '2024-10-31', 32),
(6, 11, 3, 4, 'Alta', 'Completare il deploy del SIEM sui 3 segmenti di rete mancanti. Definire use-case di monitoraggio per ambienti OT e IoT di produzione.', '2024-09-15', 4),
(7, 13, 5, 6, 'Alta', 'Eseguire un test del piano di risposta agli incidenti (tabletop exercise). Integrare procedure specifiche per incidenti su sistemi OT.', '2025-01-31', 1),
(8, 15, 5, 6, 'Alta', 'Estendere il piano di Disaster Recovery ai sistemi OT. Definire RTO/RPO per la linea di produzione. Eseguire test di failover.', '2025-03-31', 3),
(9, 10, 7, 8, 'Media', 'Implementare un processo di gestione delle configurazioni (CIS Benchmarks) per tutti i server. Automatizzare la verifica tramite strumenti di compliance.', '2025-01-31', 4),
(10, 14, 7, 8, 'Media', 'Redigere e testare le procedure di comunicazione degli incidenti verso ACN e stakeholder. Nominare un referente per le notifiche NIS2.', '2024-12-31', 40),
(11, 6, 9, 10, 'Alta', 'Completare il vendor risk assessment per i restanti 7 fornitori critici. Inserire clausole di sicurezza nei contratti di rinnovo.', '2025-06-30', 6),
(12, 15, 9, 10, 'Alta', 'Includere i sistemi di produzione nel BCP. Verificare RTO per la linea 1 e linea 2. Stipulare accordi di continuità con i fornitori chiave.', '2025-09-30', 3),
(13, 9, 11, 12, 'Media', 'Estendere la cifratura dei dati alle workstation degli ingegneri R&D. Verificare l integrità dei backup OT con restore test trimestrali.', '2025-07-31', 8),
(14, 5, 13, 14, 'Media', 'Integrare i risultati dei VA nella supply chain risk assessment. Richiedere rapporti di sicurezza ai fornitori con accesso remoto privilegiato.', '2025-12-31', 8),
(15, 2, 15, 2, 'Alta', 'Aggiornare la strategia di gestione del rischio in conformità alle nuove linee guida ACN 2025. Presentare al board entro Q1 2026.', '2026-03-31', 1);


CREATE TABLE `misura_sicurezza` (
  `id_misura` bigint(20) UNSIGNED NOT NULL,
  `codice` varchar(20) NOT NULL,
  `funzione_acn` varchar(10) NOT NULL CHECK (`funzione_acn` in ('GV','ID','PR','DE','RS','RC')),
  `nome` varchar(150) NOT NULL,
  `descrizione` text DEFAULT NULL,
  `livello_minimo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `misura_sicurezza` (`id_misura`, `codice`, `funzione_acn`, `nome`, `descrizione`, `livello_minimo`) VALUES
(1, 'GV.OC-01', 'GV', 'Contesto organizzativo e missione', 'Definire e documentare la missione, i valori e il contesto operativo dell organizzazione ai fini della cybersecurity.', 1),
(2, 'GV.RM-01', 'GV', 'Strategia di gestione del rischio', 'Stabilire e comunicare le priorità di gestione del rischio cyber, le tolleranze e le dichiarazioni di propensione al rischio.', 1),
(3, 'ID.AM-01', 'ID', 'Inventario degli asset hardware', 'Mantenere un inventario aggiornato di tutti i dispositivi hardware autorizzati collegati alla rete aziendale.', 1),
(4, 'ID.AM-02', 'ID', 'Inventario degli asset software', 'Censire tutte le applicazioni software e i sistemi operativi installati, compresi firmware e librerie di terze parti.', 1),
(5, 'ID.RA-01', 'ID', 'Identificazione delle vulnerabilità', 'Identificare e documentare le vulnerabilità degli asset critici attraverso attività di vulnerability assessment periodiche.', 2),
(6, 'ID.SC-01', 'ID', 'Gestione del rischio supply chain', 'Identificare, stabilire e valutare i processi per gestire i rischi cyber derivanti dalla catena di fornitura.', 2),
(7, 'PR.AA-01', 'PR', 'Gestione delle identità e degli accessi', 'Implementare policy di gestione delle identità, autenticazione e autorizzazione per tutti gli utenti e i sistemi.', 1),
(8, 'PR.AT-01', 'PR', 'Consapevolezza e formazione del personale', 'Garantire che il personale riceva formazione periodica sulla cybersecurity adeguata al proprio ruolo.', 1),
(9, 'PR.DS-01', 'PR', 'Protezione dei dati a riposo', 'Proteggere i dati sensibili memorizzati mediante cifratura, controllo degli accessi e procedure di backup verificate.', 2),
(10, 'PR.IR-01', 'PR', 'Gestione della configurazione sicura', 'Stabilire e mantenere configurazioni sicure di base per tutti i sistemi IT e OT, riducendo la superficie di attacco.', 2),
(11, 'DE.CM-01', 'DE', 'Monitoraggio continuo della rete', 'Monitorare la rete e i sistemi in modo continuo per rilevare eventi e anomalie di sicurezza potenzialmente dannosi.', 2),
(12, 'DE.AE-01', 'DE', 'Analisi degli eventi di sicurezza', 'Analizzare gli eventi di sicurezza per comprendere l impatto, l origine e la portata degli incidenti rilevati.', 2),
(13, 'RS.MA-01', 'RS', 'Piano di risposta agli incidenti', 'Sviluppare, mantenere e testare un piano di risposta agli incidenti di sicurezza che includa ruoli e comunicazioni.', 2),
(14, 'RS.CO-01', 'RS', 'Comunicazione degli incidenti', 'Gestire le comunicazioni durante e dopo un incidente con le parti interessate interne ed esterne, incluse le autorità.', 2),
(15, 'RC.RP-01', 'RC', 'Piano di ripristino delle attività', 'Definire e testare piani di continuità operativa e disaster recovery per i servizi e i sistemi critici identificati.', 1);


CREATE TABLE `profilo_acn` (
  `id_profilo` bigint(20) UNSIGNED NOT NULL,
  `tipo` varchar(10) NOT NULL CHECK (`tipo` in ('corrente','obiettivo')),
  `versione` varchar(20) NOT NULL DEFAULT '1.0',
  `data_valutazione` date NOT NULL,
  `id_responsabile` bigint(20) UNSIGNED DEFAULT NULL,
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `profilo_acn` (`id_profilo`, `tipo`, `versione`, `data_valutazione`, `id_responsabile`, `note`) VALUES
(1, 'corrente', '1.0', '2024-01-15', 1, 'Prima valutazione baseline dell anno 2024. Eseguita dal CISO con supporto IT.'),
(2, 'obiettivo', '1.0', '2024-01-15', 1, 'Profilo target atteso a 12 mesi dalla baseline. Approvato dal CdA.'),
(3, 'corrente', '1.1', '2024-04-10', 1, 'Rivalutazione post-implementazione firewall e segmentazione VLAN.'),
(4, 'obiettivo', '1.1', '2024-04-10', 3, 'Obiettivo aggiornato dopo revisione roadmap tecnologica Q2 2024.'),
(5, 'corrente', '1.2', '2024-07-08', 1, 'Valutazione semestrale: inclusi asset OT e sistemi produzione linea 1.'),
(6, 'obiettivo', '1.2', '2024-07-08', 3, 'Target esteso ai sistemi OT. Richiede budget aggiuntivo approvato.'),
(7, 'corrente', '1.3', '2024-10-15', 8, 'Assessment trimestrale affidato alla Specialista Cybersecurity.'),
(8, 'obiettivo', '1.3', '2024-10-15', 1, 'Obiettivo Q4 2024: completamento misure PR e avvio programma DE.'),
(9, 'corrente', '2.0', '2025-01-20', 1, 'Valutazione annuale 2025. Recepimento aggiornamenti framework ACN v2.'),
(10, 'obiettivo', '2.0', '2025-01-20', 40, 'Piano obiettivo 2025 redatto con il Responsabile Conformità.'),
(11, 'corrente', '2.1', '2025-04-14', 8, 'Verifica post-incident: incidente phishing febbraio 2025.'),
(12, 'obiettivo', '2.1', '2025-04-14', 1, 'Misure correttive post-incident da completare entro Q3 2025.'),
(13, 'corrente', '2.2', '2025-07-07', 1, 'Valutazione semestrale 2025. Prima valutazione supply chain inclusa.'),
(14, 'obiettivo', '2.2', '2025-07-07', 3, 'Target integrato con piano zero-trust per accessi remoti fornitori.'),
(15, 'corrente', '2.3', '2025-10-20', 1, 'Assessment Q4 2025: verifica conformità NIS2 in vista scadenza normativa.');


CREATE TABLE `profilo_misura` (
  `id_profilo_misura` bigint(20) UNSIGNED NOT NULL,
  `id_profilo` bigint(20) UNSIGNED NOT NULL,
  `id_misura` bigint(20) UNSIGNED NOT NULL,
  `livello_maturita` tinyint(1) NOT NULL DEFAULT 0 CHECK (`livello_maturita` between 0 and 5),
  `stato` varchar(30) DEFAULT 'Non valutato' CHECK (`stato` in ('Non valutato','Parziale','Conforme','Non applicabile')),
  `evidenze` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `profilo_misura` (`id_profilo_misura`, `id_profilo`, `id_misura`, `livello_maturita`, `stato`, `evidenze`) VALUES
(1, 1, 1, 2, 'Parziale', 'Documento di missione presente ma non aggiornato al 2024. Mancano obiettivi di sicurezza formalizzati.'),
(2, 1, 2, 1, 'Parziale', 'Esiste una policy di rischio generica non specifica per la cybersecurity. In revisione.'),
(3, 1, 3, 3, 'Conforme', 'Inventario hardware gestito su CMDB aggiornato trimestralmente. Copertura 98% degli asset censiti.'),
(4, 1, 4, 2, 'Parziale', 'Inventario software parziale: copre i server ma non le workstation OT. Piano di estensione in corso.'),
(5, 1, 5, 2, 'Parziale', 'VA eseguiti su perimetro esterno. Sistemi OT e macchine produzione non ancora inclusi.'),
(6, 1, 6, 1, 'Non valutato', 'Nessuna procedura formalizzata per valutazione rischio fornitori. Avvio previsto Q2 2024.'),
(7, 2, 1, 4, 'Conforme', 'Obiettivo: contesto e missione formalizzati e integrati nel piano strategico aziendale.'),
(8, 2, 7, 3, 'Conforme', 'IAM implementato tramite Active Directory con MFA su tutti gli accessi VPN e cloud.'),
(9, 3, 5, 3, 'Conforme', 'Post-revisione: VA ora include perimetro OT. Scansioni mensili automatizzate attive.'),
(10, 3, 11, 2, 'Parziale', 'SIEM in fase di deploy. Monitoraggio attivo solo su 3 segmenti su 6. Completamento previsto Q3 2024.'),
(11, 5, 9, 3, 'Conforme', 'Cifratura AES-256 attiva su NAS e backup. Policy di retention documentata e testata.'),
(12, 5, 13, 2, 'Parziale', 'Piano di risposta agli incidenti redatto ma non testato con simulazioni. Prima esercitazione pianificata.'),
(13, 7, 12, 3, 'Conforme', 'Correlazione eventi attiva su SIEM con regole custom per anomalie OT. Falsi positivi sotto soglia accettabile.'),
(14, 9, 6, 3, 'Conforme', 'Procedura vendor risk assessment implementata. Questionari inviati a 18 fornitori critici su 25.'),
(15, 9, 15, 2, 'Parziale', 'Piano DR testato solo per sistemi IT core. Sistemi OT e linea di produzione non ancora inclusi nel BCP.');


CREATE TABLE `report_conformita_acn` (
`Servizio_Critico` varchar(100)
,`Classe_Critica_ACN` varchar(20)
,`Asset_Tecnologico` varchar(100)
,`Categoria_Risorsa` varchar(50)
,`Punto_Contatto_Responsabile` varchar(101)
,`Email_Referente` varchar(100)
,`Supporto_Terze_Parti` varchar(100)
);


CREATE TABLE `rilevazioni_sicurezza` (
  `id_rilevazione` bigint(20) UNSIGNED NOT NULL,
  `id_asset` bigint(20) UNSIGNED DEFAULT NULL,
  `id_vulnerabilita` bigint(20) UNSIGNED DEFAULT NULL,
  `id_assessment` bigint(20) UNSIGNED DEFAULT NULL,
  `stato_remediation` varchar(30) DEFAULT 'Aperta' CHECK (`stato_remediation` in ('Aperta','In Gestione','Risolta','Rischio Accettato')),
  `data_scadenza_patch` date DEFAULT NULL,
  `note_tecniche` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `rilevazioni_sicurezza` (`id_rilevazione`, `id_asset`, `id_vulnerabilita`, `id_assessment`, `stato_remediation`, `data_scadenza_patch`, `note_tecniche`) VALUES
(1, 1, 1, 1, 'Risolta', '2024-02-01', 'Patch Log4j applicata con successo su server produzione.'),
(2, 2, 2, 2, 'In Gestione', '2024-03-15', 'Migrazione SMBv2 in corso, richiede test di compatibilità.'),
(3, 3, 5, 3, 'Aperta', '2024-04-10', 'Rilevata SQL Injection su portale web, inviata segnalazione a sviluppo.'),
(4, 1, 4, 1, 'Risolta', '2024-02-15', 'Certificati SSL rigenerati dopo aggiornamento librerie.'),
(5, 4, 9, 2, 'In Gestione', '2024-03-20', 'Cambio password massivo su router industriali pianificato.'),
(6, 5, 6, 4, 'Aperta', '2024-04-20', 'Vulnerabilità Spring4Shell rilevata su ambiente di test.'),
(7, 6, 13, 5, 'Rischio Accettato', '2024-03-01', 'Protocollo TLS 1.1 mantenuto per compatibilità con vecchio macchinario CNC.'),
(8, 2, 8, 2, 'Risolta', '2024-03-01', 'Exchange Server aggiornato ultimo Cumulative Update.'),
(9, 7, 10, 9, 'In Gestione', '2024-08-15', 'Patching Domain Controller in corso durante finestra di manutenzione.'),
(10, 8, 14, 10, 'Aperta', '2024-09-01', 'VPN Fortinet esposta, aggiornamento firmware urgente richiesto.'),
(11, 3, 11, 7, 'Risolta', '2024-06-15', 'Configurazione Nginx corretta e PHP aggiornato alla 8.1.'),
(12, 1, 12, 8, 'Risolta', '2024-07-20', 'Browser aziendali aggiornati tramite policy centralizzata.'),
(13, 9, 15, 10, 'In Gestione', '2024-09-30', 'Configurazione MFA su account amministrativi in corso.'),
(14, 4, 3, 2, 'Risolta', '2024-03-10', 'Applicata patch Microsoft Outlook su tutte le workstation.'),
(15, 10, 7, 13, 'Aperta', '2024-11-30', 'WinRAR obsoleto rilevato su postazioni ufficio acquisti.');


CREATE TABLE `servizi` (
  `id_servizio` bigint(20) UNSIGNED NOT NULL,
  `nome_servizio` varchar(100) NOT NULL,
  `criticita_acn` varchar(20) DEFAULT NULL CHECK (`criticita_acn` in ('Alta','Media','Bassa')),
  `tempo_max_fermo_ore` int(11) DEFAULT NULL,
  `id_responsabile` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `servizi` (`id_servizio`, `nome_servizio`, `criticita_acn`, `tempo_max_fermo_ore`, `id_responsabile`) VALUES
(1, 'Linea Produzione Schede Madri (SMT)', 'Alta', 2, 5),
(2, 'Sistema Controllo Qualità Ottica (AOI)', 'Alta', 4, 14),
(3, 'Infrastruttura Server SAP/ERP', 'Alta', 4, 4),
(4, 'Sviluppo e Compilazione Firmware', 'Media', 12, 12),
(5, 'Gestione Magazzino Automatizzato', 'Alta', 6, 29),
(6, 'Progettazione Circuitale CAD', 'Media', 24, 38),
(7, 'Sistema di Monitoraggio SOC/Cybersecurity', 'Alta', 1, 1),
(8, 'Servizio Posta Elettronica Aziendale', 'Media', 8, 7),
(9, 'Backup e Disaster Recovery Cloud', 'Alta', 2, 8),
(10, 'Gestione Identità e Accessi (Active Directory)', 'Alta', 1, 4),
(11, 'Controllo Numerico CNC (Meccanica)', 'Media', 12, 19),
(12, 'Sistema Test di Burn-in Componenti', 'Alta', 6, 26),
(13, 'Piattaforma E-commerce B2B', 'Media', 8, 34),
(14, 'Gestione Documentale Normative ISO', 'Bassa', 48, 40),
(15, 'Sistema Controllo Accessi Fisici (Badge)', 'Alta', 4, 13),
(16, 'Monitoraggio Ambientale Camera Bianca', 'Alta', 2, 10),
(17, 'Servizio Telefonia VoIP e Centralino', 'Bassa', 24, 36),
(18, 'Gestione Logistica Spedizioni', 'Media', 8, 6),
(19, 'Repository Codice Sorgente (GitLab)', 'Alta', 4, 3),
(20, 'Sistema Paghe e Amministrazione', 'Bassa', 72, 33),
(21, 'Manutenzione Predittiva IoT', 'Media', 24, 17),
(22, 'Portale Web Fornitori', 'Media', 12, 35),
(23, 'Sistema di Videosorveglianza IP', 'Media', 6, 1),
(24, 'Laboratorio Ricerca e Sviluppo (R&D)', 'Bassa', 48, 11),
(25, 'Infrastruttura Wi-Fi Industriale', 'Media', 4, 9);


CREATE TABLE `storico_asset` (
  `id_storico` bigint(20) UNSIGNED NOT NULL,
  `id_asset` bigint(20) UNSIGNED DEFAULT NULL,
  `vecchio_proprietario_id` bigint(20) UNSIGNED DEFAULT NULL,
  `data_modifica` timestamp NOT NULL DEFAULT current_timestamp(),
  `nota_modifica` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE `vista_gap_analisi` (
`id_gap` bigint(20) unsigned
,`codice_misura` varchar(20)
,`funzione_acn` varchar(10)
,`nome_misura` varchar(150)
,`livello_corrente` tinyint(1)
,`livello_obiettivo` tinyint(1)
,`delta_maturita` int(5)
,`priorita` varchar(10)
,`piano_azione` text
,`scadenza` date
,`responsabile` varchar(101)
);


CREATE TABLE `vulnerabilita` (
  `id_vulnerabilita` bigint(20) UNSIGNED NOT NULL,
  `codice_cve` varchar(20) DEFAULT NULL,
  `descrizione` text NOT NULL,
  `severita` varchar(20) DEFAULT NULL CHECK (`severita` in ('Critica','Alta','Media','Bassa')),
  `cvss_score` decimal(3,1) DEFAULT NULL,
  `soluzione_consigliata` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `vulnerabilita` (`id_vulnerabilita`, `codice_cve`, `descrizione`, `severita`, `cvss_score`, `soluzione_consigliata`) VALUES
(1, 'CVE-2021-44228', 'Log4Shell: Esecuzione di codice remoto nel framework Apache Log4j.', 'Critica', 10.0, 'Aggiornare Log4j alla versione 2.17.1 o superiore.'),
(2, 'CVE-2017-0144', 'EternalBlue: Vulnerabilità nel protocollo SMBv1 sfruttata da WannaCry.', 'Critica', 8.1, 'Disabilitare SMBv1 e applicare la patch MS17-010.'),
(3, 'CVE-2023-23397', 'Privilege Escalation in Microsoft Outlook tramite file audio malevoli.', 'Alta', 9.8, 'Installare gli aggiornamenti di sicurezza Microsoft di Marzo 2023.'),
(4, 'CVE-2014-0160', 'Heartbleed: Lettura memoria sensibile in OpenSSL (Information Leak).', 'Alta', 7.5, 'Aggiornare OpenSSL e rigenerare le chiavi private dei certificati SSL.'),
(5, 'N/A-OWASP-01', 'SQL Injection nel modulo di login del portale fornitori.', 'Alta', 8.5, 'Utilizzare Prepared Statements e validazione rigorosa dell input.'),
(6, 'CVE-2022-22965', 'Spring4Shell: Remote Code Execution nel framework Spring Core.', 'Critica', 9.8, 'Aggiornare a Spring Framework 5.3.18 o versioni successive.'),
(7, 'CVE-2023-38831', 'Vulnerabilità di WinRAR nella elaborazione di estensioni di file contraffatte.', 'Alta', 7.8, 'Aggiornare WinRAR alla versione 6.23 o superiore.'),
(8, 'CVE-2021-34473', 'ProxyShell: Catena di vulnerabilità in Microsoft Exchange Server.', 'Critica', 9.8, 'Installare i Cumulative Update (CU) rilasciati da Microsoft.'),
(9, 'N/A-MISC-02', 'Utilizzo di password di default (admin/admin) su pannello router industriale.', 'Alta', 8.0, 'Imporre il cambio password al primo accesso e disabilitare telnet.'),
(10, 'CVE-2020-1472', 'Zerologon: Elevazione dei privilegi nel protocollo Netlogon di Windows.', 'Critica', 10.0, 'Applicare la patch di sicurezza del Domain Controller Microsoft.'),
(11, 'CVE-2019-11043', 'Remote Code Execution in PHP-FPM in configurazioni Nginx.', 'Alta', 8.1, 'Aggiornare PHP alla versione corretta e modificare la configurazione FastCGI.'),
(12, 'CVE-2023-4863', 'Heap Buffer Overflow nella libreria libwebp (Google Chrome/Edge).', 'Alta', 8.8, 'Aggiornare il browser e le librerie grafiche di sistema.'),
(13, 'N/A-WEAK-01', 'Protocollo TLS 1.0/1.1 abilitato su web server aziendale.', 'Media', 4.3, 'Disabilitare TLS 1.0/1.1 e forzare uso di TLS 1.2 o 1.3.'),
(14, 'CVE-2018-13379', 'Path Traversal nel portale VPN Fortinet FortiGate.', 'Alta', 9.8, 'Aggiornare il firmware FortiOS alla versione più recente.'),
(15, 'N/A-AUTH-03', 'Mancata implementazione della Multi-Factor Authentication (MFA).', 'Media', 5.5, 'Abilitare MFA tramite TOTP o chiavi hardware FIDO2.');


DROP TABLE IF EXISTS `report_conformita_acn`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `report_conformita_acn`  AS SELECT `s`.`nome_servizio` AS `Servizio_Critico`, `s`.`criticita_acn` AS `Classe_Critica_ACN`, `a`.`nome_macchinario` AS `Asset_Tecnologico`, `a`.`tipo_asset` AS `Categoria_Risorsa`, concat(`dip`.`nome`,' ',`dip`.`cognome`) AS `Punto_Contatto_Responsabile`, `dip`.`email` AS `Email_Referente`, coalesce(`f`.`nome_azienda`,'Manutenzione Interna') AS `Supporto_Terze_Parti` FROM ((((`servizi` `s` left join `dipendenti` `dip` on(`s`.`id_responsabile` = `dip`.`id_dipendente`)) left join `dipendenze_asset_servizio` `das` on(`s`.`id_servizio` = `das`.`id_servizio`)) left join `asset` `a` on(`das`.`id_asset` = `a`.`id_asset`)) left join `fornitori` `f` on(`a`.`id_fornitore` = `f`.`id_fornitore`)) ;

DROP TABLE IF EXISTS `vista_gap_analisi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_gap_analisi`  AS SELECT `ga`.`id_gap` AS `id_gap`, `ms`.`codice` AS `codice_misura`, `ms`.`funzione_acn` AS `funzione_acn`, `ms`.`nome` AS `nome_misura`, `pm_c`.`livello_maturita` AS `livello_corrente`, `pm_o`.`livello_maturita` AS `livello_obiettivo`, `pm_o`.`livello_maturita`- `pm_c`.`livello_maturita` AS `delta_maturita`, `ga`.`priorita` AS `priorita`, `ga`.`piano_azione` AS `piano_azione`, `ga`.`scadenza` AS `scadenza`, concat(`dip`.`nome`,' ',`dip`.`cognome`) AS `responsabile` FROM ((((`gap_analisi` `ga` join `misura_sicurezza` `ms` on(`ga`.`id_misura` = `ms`.`id_misura`)) join `profilo_misura` `pm_c` on(`pm_c`.`id_misura` = `ga`.`id_misura` and `pm_c`.`id_profilo` = `ga`.`id_profilo_corrente`)) join `profilo_misura` `pm_o` on(`pm_o`.`id_misura` = `ga`.`id_misura` and `pm_o`.`id_profilo` = `ga`.`id_profilo_obiettivo`)) left join `dipendenti` `dip` on(`ga`.`id_responsabile` = `dip`.`id_dipendente`)) WHERE `pm_o`.`livello_maturita` - `pm_c`.`livello_maturita` > 0 ORDER BY `ga`.`priorita` ASC, `pm_o`.`livello_maturita`- `pm_c`.`livello_maturita` DESC ;


ALTER TABLE `assessment`
  ADD PRIMARY KEY (`id_assessment`),
  ADD KEY `fk_assessment_esecutore_interno` (`esecutore_interno_id`),
  ADD KEY `fk_assessment_fornitore_esterno` (`fornitore_esterno_id`);


ALTER TABLE `asset`
  ADD PRIMARY KEY (`id_asset`),
  ADD KEY `fk_asset_proprietario` (`id_proprietario`),
  ADD KEY `fk_asset_fornitore` (`id_fornitore`);


ALTER TABLE `dipendenti`
  ADD PRIMARY KEY (`id_dipendente`),
  ADD UNIQUE KEY `email` (`email`);


ALTER TABLE `dipendenze_asset_servizio`
  ADD PRIMARY KEY (`id_asset`,`id_servizio`),
  ADD KEY `fk_das_servizio` (`id_servizio`);


ALTER TABLE `fornitori`
  ADD PRIMARY KEY (`id_fornitore`);


ALTER TABLE `gap_analisi`
  ADD PRIMARY KEY (`id_gap`),
  ADD KEY `fk_gap_misura` (`id_misura`),
  ADD KEY `fk_gap_corrente` (`id_profilo_corrente`),
  ADD KEY `fk_gap_obiettivo` (`id_profilo_obiettivo`),
  ADD KEY `fk_gap_responsabile` (`id_responsabile`);


ALTER TABLE `misura_sicurezza`
  ADD PRIMARY KEY (`id_misura`),
  ADD UNIQUE KEY `codice` (`codice`);


ALTER TABLE `profilo_acn`
  ADD PRIMARY KEY (`id_profilo`),
  ADD KEY `fk_profilo_responsabile` (`id_responsabile`);


ALTER TABLE `profilo_misura`
  ADD PRIMARY KEY (`id_profilo_misura`),
  ADD UNIQUE KEY `uq_profilo_misura` (`id_profilo`,`id_misura`),
  ADD KEY `fk_pm_misura` (`id_misura`);


ALTER TABLE `rilevazioni_sicurezza`
  ADD PRIMARY KEY (`id_rilevazione`),
  ADD KEY `fk_rilevazioni_asset` (`id_asset`),
  ADD KEY `fk_rilevazioni_vulnerabilita` (`id_vulnerabilita`),
  ADD KEY `fk_rilevazioni_assessment` (`id_assessment`);


ALTER TABLE `servizi`
  ADD PRIMARY KEY (`id_servizio`),
  ADD KEY `fk_servizi_responsabile` (`id_responsabile`);


ALTER TABLE `storico_asset`
  ADD PRIMARY KEY (`id_storico`),
  ADD KEY `fk_storico_asset` (`id_asset`),
  ADD KEY `fk_storico_vecchio_proprietario` (`vecchio_proprietario_id`);


ALTER TABLE `vulnerabilita`
  ADD PRIMARY KEY (`id_vulnerabilita`);


ALTER TABLE `assessment`
  MODIFY `id_assessment` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;


ALTER TABLE `asset`
  MODIFY `id_asset` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;


ALTER TABLE `dipendenti`
  MODIFY `id_dipendente` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;


ALTER TABLE `fornitori`
  MODIFY `id_fornitore` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;


ALTER TABLE `gap_analisi`
  MODIFY `id_gap` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;


ALTER TABLE `misura_sicurezza`
  MODIFY `id_misura` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;


ALTER TABLE `profilo_acn`
  MODIFY `id_profilo` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;


ALTER TABLE `profilo_misura`
  MODIFY `id_profilo_misura` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;


ALTER TABLE `rilevazioni_sicurezza`
  MODIFY `id_rilevazione` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;


ALTER TABLE `servizi`
  MODIFY `id_servizio` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;


ALTER TABLE `storico_asset`
  MODIFY `id_storico` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;


ALTER TABLE `vulnerabilita`
  MODIFY `id_vulnerabilita` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;


ALTER TABLE `assessment`
  ADD CONSTRAINT `fk_assessment_esecutore_interno` FOREIGN KEY (`esecutore_interno_id`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assessment_fornitore_esterno` FOREIGN KEY (`fornitore_esterno_id`) REFERENCES `fornitori` (`id_fornitore`) ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE `asset`
  ADD CONSTRAINT `fk_asset_fornitore` FOREIGN KEY (`id_fornitore`) REFERENCES `fornitori` (`id_fornitore`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_asset_proprietario` FOREIGN KEY (`id_proprietario`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE `dipendenze_asset_servizio`
  ADD CONSTRAINT `fk_das_asset` FOREIGN KEY (`id_asset`) REFERENCES `asset` (`id_asset`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_das_servizio` FOREIGN KEY (`id_servizio`) REFERENCES `servizi` (`id_servizio`) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE `gap_analisi`
  ADD CONSTRAINT `fk_gap_corrente` FOREIGN KEY (`id_profilo_corrente`) REFERENCES `profilo_acn` (`id_profilo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_gap_misura` FOREIGN KEY (`id_misura`) REFERENCES `misura_sicurezza` (`id_misura`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_gap_obiettivo` FOREIGN KEY (`id_profilo_obiettivo`) REFERENCES `profilo_acn` (`id_profilo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_gap_responsabile` FOREIGN KEY (`id_responsabile`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE `profilo_acn`
  ADD CONSTRAINT `fk_profilo_responsabile` FOREIGN KEY (`id_responsabile`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE `profilo_misura`
  ADD CONSTRAINT `fk_pm_misura` FOREIGN KEY (`id_misura`) REFERENCES `misura_sicurezza` (`id_misura`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pm_profilo` FOREIGN KEY (`id_profilo`) REFERENCES `profilo_acn` (`id_profilo`) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE `rilevazioni_sicurezza`
  ADD CONSTRAINT `fk_rilevazioni_assessment` FOREIGN KEY (`id_assessment`) REFERENCES `assessment` (`id_assessment`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rilevazioni_asset` FOREIGN KEY (`id_asset`) REFERENCES `asset` (`id_asset`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rilevazioni_vulnerabilita` FOREIGN KEY (`id_vulnerabilita`) REFERENCES `vulnerabilita` (`id_vulnerabilita`) ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE `servizi`
  ADD CONSTRAINT `fk_servizi_responsabile` FOREIGN KEY (`id_responsabile`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE `storico_asset`
  ADD CONSTRAINT `fk_storico_asset` FOREIGN KEY (`id_asset`) REFERENCES `asset` (`id_asset`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_storico_vecchio_proprietario` FOREIGN KEY (`vecchio_proprietario_id`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;