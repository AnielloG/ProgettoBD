-- TRIGGER : verifica se un equipaggio non ha raggiunto il limite di piloti (3)
DELIMITER //

CREATE TRIGGER verifica_max_piloti
BEFORE INSERT ON Pilota
FOR EACH ROW
BEGIN
    DECLARE numero_attuale_piloti INT;

    SELECT NumeroPiloti INTO numero_attuale_piloti
    FROM Equipaggio
    WHERE IdEquipaggio = NEW.IdEquipaggio;

    IF numero_attuale_piloti >= 3 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Impossibile aggiungere il pilota: il numero massimo di piloti (3) per equipaggio è stato raggiunto.';
    ELSE
        UPDATE Equipaggio
        SET NumeroPiloti = NumeroPiloti + 1
        WHERE IdEquipaggio = NEW.IdEquipaggio;
    END IF;
END;

//
DELIMITER ;

-- TRIGGER: verifica che un equipaggio non abbia solo gentleman driver
DELIMITER //

CREATE TRIGGER verifica_composizione_equipaggio
BEFORE INSERT ON Pilota
FOR EACH ROW
BEGIN
    DECLARE numero_piloti_totali INT;
    DECLARE numero_gentleman_driver INT;

    -- Conta il numero totale di piloti nell'equipaggio
    SELECT COUNT(*) INTO numero_piloti_totali FROM Pilota WHERE IdEquipaggio = NEW.IdEquipaggio;

    -- Conta il numero di piloti Gentleman Driver nell'equipaggio
    SELECT COUNT(*) INTO numero_gentleman_driver FROM Pilota WHERE IdEquipaggio = NEW.IdEquipaggio AND Tipo = 'Gentleman Driver';

    -- Verifica se l'aggiunta del nuovo pilota Gentleman Driver rende l'equipaggio composto esclusivamente da Gentleman Driver
    IF NEW.Tipo = 'Gentleman Driver' AND numero_gentleman_driver = numero_piloti_totali THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Un equipaggio non può essere composto esclusivamente da piloti tipo Gentleman Driver.';
    END IF;
END;

//
DELIMITER ;


-- TRIGGER: verifica le licenze e i tipi di pilota inseriti
DELIMITER //

CREATE TRIGGER verifica_tipo_licenza
BEFORE INSERT ON Pilota
FOR EACH ROW
BEGIN
    IF NEW.Tipo = 'AM' OR NEW.Tipo = 'Gentleman Driver' THEN
        IF NEW.NumeroLicenze != 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Un pilota AM o Gentleman Driver deve avere esattamente una licenza.';
        END IF;
    ELSEIF NEW.Tipo = 'PRO' THEN
        IF NEW.NumeroLicenze <= 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Un pilota PRO deve avere più di una licenza.';
        END IF;
    END IF;
END;

//
DELIMITER ;

-- TRIGGER: verifica il tipo di componente e i suoi attributi
DELIMITER //

CREATE TRIGGER verifica_attributi_componente
BEFORE INSERT ON Componente
FOR EACH ROW
BEGIN
    IF NEW.TipologiaComponente = 'motore' THEN
        IF NEW.MotoreTipo IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare il tipo di motore.';
        END IF;
    ELSEIF NEW.TipologiaComponente = 'cambio' THEN
        IF NEW.CambioMarce IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare il numero di marce del cambio.';
        END IF;
    ELSEIF NEW.TipologiaComponente = 'telaio' THEN
        IF NEW.TelaioMateriale IS NULL OR NEW.TelaioPeso IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare il materiale e il peso del telaio.';
        END IF;
    END IF;
END;

//
DELIMITER ;

-- TRIGGER: verifica che un circuito sia utilizzato max in 2 gare
DELIMITER //

CREATE TRIGGER verifica_uso_circuito
BEFORE INSERT ON Gara
FOR EACH ROW
BEGIN
    DECLARE numero_gare_sul_circuito INT;

    SELECT COUNT(*) INTO numero_gare_sul_circuito 
    FROM Gara
    WHERE IdCircuito = NEW.IdCircuito;

    IF numero_gare_sul_circuito >= 2 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Un circuito può essere utilizzato per un massimo di due gare.';
    END IF;
END;

//
DELIMITER ;

-- verifica che un pilota sia gm prima di fargli fare un finanziamento 
DELIMITER //

CREATE TRIGGER CheckGentlemanDriverBeforeFinanziamento
BEFORE INSERT ON Finanziamento
FOR EACH ROW
BEGIN
    DECLARE pilotaTipo VARCHAR(255);

    -- Recupera il tipo del pilota
    SELECT Tipo INTO pilotaTipo FROM Pilota WHERE IdPilota = NEW.IdPilota;

    -- Se il pilota non è un Gentleman Driver, impedisce l'inserimento
    IF pilotaTipo != 'Gentleman Driver' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo i piloti Gentleman Driver possono effettuare finanziamenti.';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER verifica_numero_componenti_forniti
BEFORE INSERT ON Componente
FOR EACH ROW
BEGIN
    DECLARE num_componenti_forniti INT;

    -- Recupera il numero corrente di componenti forniti dal costruttore
    SELECT NumeroComponentiForniti INTO num_componenti_forniti
    FROM Costruttore
    WHERE IdCostruttore = NEW.IdCostruttore;

    -- Se il numero di componenti forniti è già 3, impedisce l'inserimento
    IF num_componenti_forniti >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il costruttore ha già fornito il massimo numero di componenti consentito (3).';
    ELSE
        -- Aggiorna il conteggio dei componenti forniti dal costruttore
        UPDATE Costruttore
        SET NumeroComponentiForniti = NumeroComponentiForniti + 1
        WHERE IdCostruttore = NEW.IdCostruttore;
    END IF;
END;

//
DELIMITER ;

