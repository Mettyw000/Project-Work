-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Apr 30, 2026 alle 18:13
-- Versione del server: 10.4.32-MariaDB
-- Versione PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `registroacn`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `assessment`
--

CREATE TABLE `assessment` (
  `id_assessment` bigint(20) UNSIGNED NOT NULL,
  `tipo_test` varchar(50) DEFAULT NULL CHECK (`tipo_test` in ('Vulnerability Assessment','Penetration Test','Code Review')),
  `data_esecuzione` date NOT NULL,
  `esecutore_interno_id` bigint(20) UNSIGNED DEFAULT NULL,
  `fornitore_esterno_id` bigint(20) UNSIGNED DEFAULT NULL,
  `report_file_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `asset`
--

CREATE TABLE `asset` (
  `id_asset` bigint(20) UNSIGNED NOT NULL,
  `nome_macchinario` varchar(100) NOT NULL,
  `tipo_asset` varchar(50) DEFAULT NULL,
  `ubicazione` varchar(100) DEFAULT NULL,
  `id_proprietario` bigint(20) UNSIGNED DEFAULT NULL,
  `id_fornitore` bigint(20) UNSIGNED DEFAULT NULL,
  `data_ultimo_aggiornamento` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Trigger `asset`
--
DELIMITER $$
CREATE TRIGGER `trg_storico_proprietario_after_update` AFTER UPDATE ON `asset` FOR EACH ROW BEGIN
    -- Si attiva SOLO se il proprietario è effettivamente cambiato
    IF (OLD.id_proprietario <> NEW.id_proprietario)
       OR (OLD.id_proprietario IS NULL AND NEW.id_proprietario IS NOT NULL)
       OR (OLD.id_proprietario IS NOT NULL AND NEW.id_proprietario IS NULL)
    THEN
        INSERT INTO `storico_asset`
            (`id_asset`, `vecchio_proprietario_id`, `data_modifica`, `nota_modifica`)
        VALUES (
            OLD.id_asset,
            OLD.id_proprietario,
            NOW(),
            CONCAT(
                'Cambio automatico registrato da trigger. ',
                'Asset: "', OLD.nome_macchinario, '". ',
                'Vecchio proprietario ID: ', COALESCE(CAST(OLD.id_proprietario AS CHAR), 'NULL'), '. ',
                'Nuovo proprietario ID: ', COALESCE(CAST(NEW.id_proprietario AS CHAR), 'NULL'), '.'
            )
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `dipendenti`
--

CREATE TABLE `dipendenti` (
  `id_dipendente` bigint(20) UNSIGNED NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cognome` varchar(50) NOT NULL,
  `ruolo` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `dipendenze_asset_servizio`
--

CREATE TABLE `dipendenze_asset_servizio` (
  `id_asset` bigint(20) UNSIGNED NOT NULL,
  `id_servizio` bigint(20) UNSIGNED NOT NULL,
  `impatto_guasto` varchar(50) DEFAULT 'Parziale'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `fornitori`
--

CREATE TABLE `fornitori` (
  `id_fornitore` bigint(20) UNSIGNED NOT NULL,
  `nome_azienda` varchar(100) NOT NULL,
  `contatto_emergenza` varchar(100) DEFAULT NULL,
  `livello_accesso` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `gap_analisi`
--

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

-- --------------------------------------------------------

--
-- Struttura della tabella `misura_sicurezza`
--

CREATE TABLE `misura_sicurezza` (
  `id_misura` bigint(20) UNSIGNED NOT NULL,
  `codice` varchar(20) NOT NULL,
  `funzione_acn` varchar(10) NOT NULL CHECK (`funzione_acn` in ('GV','ID','PR','DE','RS','RC')),
  `nome` varchar(150) NOT NULL,
  `descrizione` text DEFAULT NULL,
  `livello_minimo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `profilo_acn`
--

CREATE TABLE `profilo_acn` (
  `id_profilo` bigint(20) UNSIGNED NOT NULL,
  `tipo` varchar(10) NOT NULL CHECK (`tipo` in ('corrente','obiettivo')),
  `versione` varchar(20) NOT NULL DEFAULT '1.0',
  `data_valutazione` date NOT NULL,
  `id_responsabile` bigint(20) UNSIGNED DEFAULT NULL,
  `note` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `profilo_misura`
--

CREATE TABLE `profilo_misura` (
  `id_profilo_misura` bigint(20) UNSIGNED NOT NULL,
  `id_profilo` bigint(20) UNSIGNED NOT NULL,
  `id_misura` bigint(20) UNSIGNED NOT NULL,
  `livello_maturita` tinyint(1) NOT NULL DEFAULT 0 CHECK (`livello_maturita` between 0 and 5),
  `stato` varchar(30) DEFAULT 'Non valutato' CHECK (`stato` in ('Non valutato','Parziale','Conforme','Non applicabile')),
  `evidenze` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `report_conformita_acn`
-- (Vedi sotto per la vista effettiva)
--
CREATE TABLE `report_conformita_acn` (
`Servizio_Critico` varchar(100)
,`Classe_Critica_ACN` varchar(20)
,`Asset_Tecnologico` varchar(100)
,`Categoria_Risorsa` varchar(50)
,`Punto_Contatto_Responsabile` varchar(101)
,`Email_Referente` varchar(100)
,`Supporto_Terze_Parti` varchar(100)
);

-- --------------------------------------------------------

--
-- Struttura della tabella `rilevazioni_sicurezza`
--

CREATE TABLE `rilevazioni_sicurezza` (
  `id_rilevazione` bigint(20) UNSIGNED NOT NULL,
  `id_asset` bigint(20) UNSIGNED DEFAULT NULL,
  `id_vulnerabilita` bigint(20) UNSIGNED DEFAULT NULL,
  `id_assessment` bigint(20) UNSIGNED DEFAULT NULL,
  `stato_remediation` varchar(30) DEFAULT 'Aperta' CHECK (`stato_remediation` in ('Aperta','In Gestione','Risolta','Rischio Accettato')),
  `data_scadenza_patch` date DEFAULT NULL,
  `note_tecniche` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `servizi`
--

CREATE TABLE `servizi` (
  `id_servizio` bigint(20) UNSIGNED NOT NULL,
  `nome_servizio` varchar(100) NOT NULL,
  `criticita_acn` varchar(20) DEFAULT NULL CHECK (`criticita_acn` in ('Alta','Media','Bassa')),
  `tempo_max_fermo_ore` int(11) DEFAULT NULL,
  `id_responsabile` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `storico_asset`
--

CREATE TABLE `storico_asset` (
  `id_storico` bigint(20) UNSIGNED NOT NULL,
  `id_asset` bigint(20) UNSIGNED DEFAULT NULL,
  `vecchio_proprietario_id` bigint(20) UNSIGNED DEFAULT NULL,
  `data_modifica` timestamp NOT NULL DEFAULT current_timestamp(),
  `nota_modifica` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura stand-in per le viste `vista_gap_analisi`
-- (Vedi sotto per la vista effettiva)
--
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

-- --------------------------------------------------------

--
-- Struttura della tabella `vulnerabilita`
--

CREATE TABLE `vulnerabilita` (
  `id_vulnerabilita` bigint(20) UNSIGNED NOT NULL,
  `codice_cve` varchar(20) DEFAULT NULL,
  `descrizione` text NOT NULL,
  `severita` varchar(20) DEFAULT NULL CHECK (`severita` in ('Critica','Alta','Media','Bassa')),
  `cvss_score` decimal(3,1) DEFAULT NULL,
  `soluzione_consigliata` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struttura per vista `report_conformita_acn`
--
DROP TABLE IF EXISTS `report_conformita_acn`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `report_conformita_acn`  AS SELECT `s`.`nome_servizio` AS `Servizio_Critico`, `s`.`criticita_acn` AS `Classe_Critica_ACN`, `a`.`nome_macchinario` AS `Asset_Tecnologico`, `a`.`tipo_asset` AS `Categoria_Risorsa`, concat(`dip`.`nome`,' ',`dip`.`cognome`) AS `Punto_Contatto_Responsabile`, `dip`.`email` AS `Email_Referente`, coalesce(`f`.`nome_azienda`,'Manutenzione Interna') AS `Supporto_Terze_Parti` FROM ((((`servizi` `s` left join `dipendenti` `dip` on(`s`.`id_responsabile` = `dip`.`id_dipendente`)) left join `dipendenze_asset_servizio` `das` on(`s`.`id_servizio` = `das`.`id_servizio`)) left join `asset` `a` on(`das`.`id_asset` = `a`.`id_asset`)) left join `fornitori` `f` on(`a`.`id_fornitore` = `f`.`id_fornitore`)) ;

-- --------------------------------------------------------

--
-- Struttura per vista `vista_gap_analisi`
--
DROP TABLE IF EXISTS `vista_gap_analisi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_gap_analisi`  AS SELECT `ga`.`id_gap` AS `id_gap`, `ms`.`codice` AS `codice_misura`, `ms`.`funzione_acn` AS `funzione_acn`, `ms`.`nome` AS `nome_misura`, `pm_c`.`livello_maturita` AS `livello_corrente`, `pm_o`.`livello_maturita` AS `livello_obiettivo`, `pm_o`.`livello_maturita`- `pm_c`.`livello_maturita` AS `delta_maturita`, `ga`.`priorita` AS `priorita`, `ga`.`piano_azione` AS `piano_azione`, `ga`.`scadenza` AS `scadenza`, concat(`dip`.`nome`,' ',`dip`.`cognome`) AS `responsabile` FROM ((((`gap_analisi` `ga` join `misura_sicurezza` `ms` on(`ga`.`id_misura` = `ms`.`id_misura`)) join `profilo_misura` `pm_c` on(`pm_c`.`id_misura` = `ga`.`id_misura` and `pm_c`.`id_profilo` = `ga`.`id_profilo_corrente`)) join `profilo_misura` `pm_o` on(`pm_o`.`id_misura` = `ga`.`id_misura` and `pm_o`.`id_profilo` = `ga`.`id_profilo_obiettivo`)) left join `dipendenti` `dip` on(`ga`.`id_responsabile` = `dip`.`id_dipendente`)) WHERE `pm_o`.`livello_maturita` - `pm_c`.`livello_maturita` > 0 ORDER BY `ga`.`priorita` ASC, `pm_o`.`livello_maturita`- `pm_c`.`livello_maturita` DESC ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `assessment`
--
ALTER TABLE `assessment`
  ADD PRIMARY KEY (`id_assessment`),
  ADD KEY `fk_assessment_esecutore_interno` (`esecutore_interno_id`),
  ADD KEY `fk_assessment_fornitore_esterno` (`fornitore_esterno_id`);

--
-- Indici per le tabelle `asset`
--
ALTER TABLE `asset`
  ADD PRIMARY KEY (`id_asset`),
  ADD KEY `fk_asset_proprietario` (`id_proprietario`),
  ADD KEY `fk_asset_fornitore` (`id_fornitore`);

--
-- Indici per le tabelle `dipendenti`
--
ALTER TABLE `dipendenti`
  ADD PRIMARY KEY (`id_dipendente`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indici per le tabelle `dipendenze_asset_servizio`
--
ALTER TABLE `dipendenze_asset_servizio`
  ADD PRIMARY KEY (`id_asset`,`id_servizio`),
  ADD KEY `fk_das_servizio` (`id_servizio`);

--
-- Indici per le tabelle `fornitori`
--
ALTER TABLE `fornitori`
  ADD PRIMARY KEY (`id_fornitore`);

--
-- Indici per le tabelle `gap_analisi`
--
ALTER TABLE `gap_analisi`
  ADD PRIMARY KEY (`id_gap`),
  ADD KEY `fk_gap_misura` (`id_misura`),
  ADD KEY `fk_gap_corrente` (`id_profilo_corrente`),
  ADD KEY `fk_gap_obiettivo` (`id_profilo_obiettivo`),
  ADD KEY `fk_gap_responsabile` (`id_responsabile`);

--
-- Indici per le tabelle `misura_sicurezza`
--
ALTER TABLE `misura_sicurezza`
  ADD PRIMARY KEY (`id_misura`),
  ADD UNIQUE KEY `codice` (`codice`);

--
-- Indici per le tabelle `profilo_acn`
--
ALTER TABLE `profilo_acn`
  ADD PRIMARY KEY (`id_profilo`),
  ADD KEY `fk_profilo_responsabile` (`id_responsabile`);

--
-- Indici per le tabelle `profilo_misura`
--
ALTER TABLE `profilo_misura`
  ADD PRIMARY KEY (`id_profilo_misura`),
  ADD UNIQUE KEY `uq_profilo_misura` (`id_profilo`,`id_misura`),
  ADD KEY `fk_pm_misura` (`id_misura`);

--
-- Indici per le tabelle `rilevazioni_sicurezza`
--
ALTER TABLE `rilevazioni_sicurezza`
  ADD PRIMARY KEY (`id_rilevazione`),
  ADD KEY `fk_rilevazioni_asset` (`id_asset`),
  ADD KEY `fk_rilevazioni_vulnerabilita` (`id_vulnerabilita`),
  ADD KEY `fk_rilevazioni_assessment` (`id_assessment`);

--
-- Indici per le tabelle `servizi`
--
ALTER TABLE `servizi`
  ADD PRIMARY KEY (`id_servizio`),
  ADD KEY `fk_servizi_responsabile` (`id_responsabile`);

--
-- Indici per le tabelle `storico_asset`
--
ALTER TABLE `storico_asset`
  ADD PRIMARY KEY (`id_storico`),
  ADD KEY `fk_storico_asset` (`id_asset`),
  ADD KEY `fk_storico_vecchio_proprietario` (`vecchio_proprietario_id`);

--
-- Indici per le tabelle `vulnerabilita`
--
ALTER TABLE `vulnerabilita`
  ADD PRIMARY KEY (`id_vulnerabilita`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `assessment`
--
ALTER TABLE `assessment`
  MODIFY `id_assessment` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `asset`
--
ALTER TABLE `asset`
  MODIFY `id_asset` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `dipendenti`
--
ALTER TABLE `dipendenti`
  MODIFY `id_dipendente` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `fornitori`
--
ALTER TABLE `fornitori`
  MODIFY `id_fornitore` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `gap_analisi`
--
ALTER TABLE `gap_analisi`
  MODIFY `id_gap` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `misura_sicurezza`
--
ALTER TABLE `misura_sicurezza`
  MODIFY `id_misura` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `profilo_acn`
--
ALTER TABLE `profilo_acn`
  MODIFY `id_profilo` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `profilo_misura`
--
ALTER TABLE `profilo_misura`
  MODIFY `id_profilo_misura` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `rilevazioni_sicurezza`
--
ALTER TABLE `rilevazioni_sicurezza`
  MODIFY `id_rilevazione` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `servizi`
--
ALTER TABLE `servizi`
  MODIFY `id_servizio` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `storico_asset`
--
ALTER TABLE `storico_asset`
  MODIFY `id_storico` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `vulnerabilita`
--
ALTER TABLE `vulnerabilita`
  MODIFY `id_vulnerabilita` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `assessment`
--
ALTER TABLE `assessment`
  ADD CONSTRAINT `fk_assessment_esecutore_interno` FOREIGN KEY (`esecutore_interno_id`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_assessment_fornitore_esterno` FOREIGN KEY (`fornitore_esterno_id`) REFERENCES `fornitori` (`id_fornitore`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limiti per la tabella `asset`
--
ALTER TABLE `asset`
  ADD CONSTRAINT `fk_asset_fornitore` FOREIGN KEY (`id_fornitore`) REFERENCES `fornitori` (`id_fornitore`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_asset_proprietario` FOREIGN KEY (`id_proprietario`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limiti per la tabella `dipendenze_asset_servizio`
--
ALTER TABLE `dipendenze_asset_servizio`
  ADD CONSTRAINT `fk_das_asset` FOREIGN KEY (`id_asset`) REFERENCES `asset` (`id_asset`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_das_servizio` FOREIGN KEY (`id_servizio`) REFERENCES `servizi` (`id_servizio`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `gap_analisi`
--
ALTER TABLE `gap_analisi`
  ADD CONSTRAINT `fk_gap_corrente` FOREIGN KEY (`id_profilo_corrente`) REFERENCES `profilo_acn` (`id_profilo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_gap_misura` FOREIGN KEY (`id_misura`) REFERENCES `misura_sicurezza` (`id_misura`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_gap_obiettivo` FOREIGN KEY (`id_profilo_obiettivo`) REFERENCES `profilo_acn` (`id_profilo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_gap_responsabile` FOREIGN KEY (`id_responsabile`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limiti per la tabella `profilo_acn`
--
ALTER TABLE `profilo_acn`
  ADD CONSTRAINT `fk_profilo_responsabile` FOREIGN KEY (`id_responsabile`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limiti per la tabella `profilo_misura`
--
ALTER TABLE `profilo_misura`
  ADD CONSTRAINT `fk_pm_misura` FOREIGN KEY (`id_misura`) REFERENCES `misura_sicurezza` (`id_misura`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pm_profilo` FOREIGN KEY (`id_profilo`) REFERENCES `profilo_acn` (`id_profilo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limiti per la tabella `rilevazioni_sicurezza`
--
ALTER TABLE `rilevazioni_sicurezza`
  ADD CONSTRAINT `fk_rilevazioni_assessment` FOREIGN KEY (`id_assessment`) REFERENCES `assessment` (`id_assessment`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rilevazioni_asset` FOREIGN KEY (`id_asset`) REFERENCES `asset` (`id_asset`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rilevazioni_vulnerabilita` FOREIGN KEY (`id_vulnerabilita`) REFERENCES `vulnerabilita` (`id_vulnerabilita`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limiti per la tabella `servizi`
--
ALTER TABLE `servizi`
  ADD CONSTRAINT `fk_servizi_responsabile` FOREIGN KEY (`id_responsabile`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limiti per la tabella `storico_asset`
--
ALTER TABLE `storico_asset`
  ADD CONSTRAINT `fk_storico_asset` FOREIGN KEY (`id_asset`) REFERENCES `asset` (`id_asset`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_storico_vecchio_proprietario` FOREIGN KEY (`vecchio_proprietario_id`) REFERENCES `dipendenti` (`id_dipendente`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
