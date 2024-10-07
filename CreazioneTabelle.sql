-- Creazione schema CampionatoAutomobilistico
CREATE SCHEMA CampionatoAutomobilistico;
USE CampionatoAutomobilistico;

-- Creazione tabella Circuito
CREATE TABLE `Circuito` (
  `NomeCircuito` varchar(45) NOT NULL,
  `Paese` varchar(45) NOT NULL,
  `Lunghezza` varchar(45) NOT NULL,
  `Curve` int NOT NULL,
  PRIMARY KEY (`NomeCircuito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Creazione tabella Componente
CREATE TABLE `Componente` (
  `IdComponente` int NOT NULL AUTO_INCREMENT,
  `Costo` float DEFAULT NULL,
  `TipologiaComponente` enum('motore','cambio','telaio') NOT NULL,
  `IdCostruttore` int NOT NULL,
  `IdVettura` int NOT NULL,
  `MotoreTipo` enum('aspirato','turbo') DEFAULT NULL,
  `CambioMarce` int DEFAULT NULL,
  `TelaioMateriale` varchar(255) DEFAULT NULL,
  `TelaioPeso` float DEFAULT NULL,
  PRIMARY KEY (`IdComponente`),
  UNIQUE KEY `IdVettura` (`IdVettura`,`TipologiaComponente`),
  KEY `Vettura_idx` (`IdVettura`),
  CONSTRAINT `Vettura` FOREIGN KEY (`IdVettura`) REFERENCES `Vettura` (`NumeroGara`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Creazione tabella Costruttore
CREATE TABLE `Costruttore` (
  `IdCostruttore` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(45) NOT NULL,
  `RagioneSociale` varchar(45) DEFAULT NULL,
  `Sede` varchar(45) DEFAULT NULL,
  `NumeroComponentiForniti` int NOT NULL DEFAULT '0',
  `DataFornituraComponenti` date DEFAULT NULL,
  PRIMARY KEY (`IdCostruttore`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Creazione tabella Equipaggio
CREATE TABLE `Equipaggio` (
  `IdEquipaggio` int NOT NULL AUTO_INCREMENT,
  `NumeroPiloti` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`IdEquipaggio`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Creazione tabella Finanziamento
CREATE TABLE `Finanziamento` (
  `IdFinanziamento` int NOT NULL AUTO_INCREMENT,
  `Data` date NOT NULL,
  `Importo` float NOT NULL,
  `IdScuderia` int NOT NULL,
  `IdPilota` int NOT NULL,
  PRIMARY KEY (`IdFinanziamento`),
  KEY `IdScuderia_idx` (`IdScuderia`),
  KEY `Pilota_idx` (`IdPilota`),
  CONSTRAINT `Pilota` FOREIGN KEY (`IdPilota`) REFERENCES `Pilota` (`IdPilota`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Scuderia` FOREIGN KEY (`IdScuderia`) REFERENCES `Scuderia` (`IdScuderia`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Creazione tabella Gara
CREATE TABLE `Gara` (
  `IdGara` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(45) NOT NULL,
  `Data` varchar(45) NOT NULL,
  `Durata` varchar(45) NOT NULL,
  `IdCircuito` varchar(45) DEFAULT NULL,
  `TipologiaGara` set('asciutta','bagnata') NOT NULL,
  PRIMARY KEY (`IdGara`),
  KEY `IdCircuito_idx` (`IdCircuito`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Creazione tabella Partecipazione
CREATE TABLE `Partecipazione` (
  `NumeroPartecipazione` int NOT NULL AUTO_INCREMENT,
  `PuntiVettura` int NOT NULL DEFAULT '0',
  `Piazzamento` varchar(50) DEFAULT 'N/D',
  `MotivoRitiro` varchar(150) DEFAULT NULL,
  `IdGara` int NOT NULL,
  `NumeroGara` int DEFAULT NULL,
  PRIMARY KEY (`NumeroPartecipazione`),
  UNIQUE KEY `NumeroGara` (`NumeroGara`,`IdGara`),
  UNIQUE KEY `NumeroGara_2` (`NumeroGara`,`IdGara`),
  KEY `IdGara_idx` (`IdGara`),
  KEY `NumeroGara_idx` (`NumeroGara`),
  CONSTRAINT `IdGara` FOREIGN KEY (`IdGara`) REFERENCES `Gara` (`IdGara`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `NumeroGara` FOREIGN KEY (`NumeroGara`) REFERENCES `Vettura` (`NumeroGara`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Creazione tabella Pilota
CREATE TABLE `Pilota` (
  `IdPilota` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(255) NOT NULL,
  `Cognome` varchar(255) NOT NULL,
  `Nazionalità` varchar(255) NOT NULL,
  `DataDiNascita` date NOT NULL,
  `Tipo` enum('AM','PRO','Gentleman Driver') NOT NULL,
  `IdEquipaggio` int NOT NULL,
  `DataPrimaLicenza` date NOT NULL COMMENT 'YYYY-MM-DD',
  `NumeroLicenze` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`IdPilota`),
  KEY `Equipaggio` (`IdEquipaggio`),
  CONSTRAINT `Equipaggio` FOREIGN KEY (`IdEquipaggio`) REFERENCES `Equipaggio` (`IdEquipaggio`) ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Creazione tabella Scuderia
CREATE TABLE `Scuderia` (
  `IdScuderia` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(45) NOT NULL,
  `NumeroVetture` int NOT NULL DEFAULT '0',
  `Sede` varchar(45) NOT NULL,
  `NumeroFinanziamenti` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`IdScuderia`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Creazione tabella Vettura
CREATE TABLE `Vettura` (
  `NumeroGara` int NOT NULL AUTO_INCREMENT,
  `Modello` varchar(45) NOT NULL,
  `IdScuderia` int NOT NULL,
  `IdEquipaggio` int DEFAULT NULL,
  PRIMARY KEY (`NumeroGara`),
  KEY `IdScuderia_idx` (`IdScuderia`),
  KEY `IdEquipaggio_idx` (`IdEquipaggio`),
  CONSTRAINT `IdEquipaggio` FOREIGN KEY (`IdEquipaggio`) REFERENCES `Equipaggio` (`IdEquipaggio`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `IdScuderia` FOREIGN KEY (`IdScuderia`) REFERENCES `Scuderia` (`IdScuderia`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;















