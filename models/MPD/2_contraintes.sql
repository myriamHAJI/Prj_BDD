use esn;

-- alter table

ALTER TABLE Contrat 
    ADD CONSTRAINT chk_date_contrat CHECK (date_fin IS NULL OR date_fin >= date_debut);

ALTER TABLE Mission 
    ADD CONSTRAINT chk_date_mission CHECK (date_fin IS NULL OR date_fin >= date_debut);


ALTER TABLE Possession_qualification 
    ADD CONSTRAINT chk_date_pq CHECK (date_expiration IS NULL OR date_expiration >= date_obtention);
  
ALTER TABLE Employe
    ADD CONSTRAINT chk_salaire_positif CHECK (salaire > 0),
    ADD CONSTRAINT chk_commission_positif CHECK (commission IS NULL OR commission > 0),
	  ADD CONSTRAINT chk_date_embauche CHECK (date_embauche <= CURRENT_DATE);


ALTER TABLE Livrable 
   ADD CONSTRAINT chk_numero_livrable 
   CHECK (numero >= 1);

ALTER TABLE Employe
  ADD CONSTRAINT chk_manager_diff
  CHECK (id_manager IS NULL OR id_manager <> id_employe);

-- trigger insert

DELIMITER $$

CREATE TRIGGER livrable_date_remise
BEFORE INSERT ON Livrable
FOR EACH ROW
BEGIN
  DECLARE d_debut DATE;
  SELECT date_debut INTO d_debut
  FROM Mission
  WHERE id_mission = NEW.id_mission;

  IF NEW.date_remise < d_debut THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Erreur : la date de remise du livrable doit être après la date de début de la mission.';
  END IF;
END$$

CREATE TRIGGER date_affectation_mission
BEFORE INSERT ON Effectuer_mission
FOR EACH ROW
BEGIN
  DECLARE d_debut DATE;
  DECLARE d_fin DATE;

  SELECT date_debut, date_fin INTO d_debut, d_fin
  FROM Mission
  WHERE id_mission = NEW.id_mission;

  IF NEW.date_affectation < d_debut 
     OR (d_fin IS NOT NULL AND NEW.date_affectation > d_fin) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Erreur : la date d’affectation doit être comprise dans la période de la mission.';
  END IF;
END$$

CREATE TRIGGER mission_type_contrat
BEFORE INSERT ON Mission
FOR EACH ROW
BEGIN
    IF NEW.type_mission = 'EXTERNE' AND NEW.id_contrat IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur : Une mission EXTERNE doit avoir un contrat.';
    END IF;

    IF NEW.type_mission = 'INTERNE' AND NEW.id_contrat IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur : Une mission INTERNE ne doit pas avoir de contrat.';
    END IF;
END$$

DELIMITER ;

-- trigger update

DELIMITER $$

CREATE TRIGGER livrable_date_remise
BEFORE UPDATE ON Livrable
FOR EACH ROW
BEGIN
  DECLARE d_debut DATE;
  SELECT date_debut INTO d_debut
  FROM Mission
  WHERE id_mission = NEW.id_mission;

  IF NEW.date_remise < d_debut THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Erreur : la date de remise du livrable doit être après la date de début de la mission.';
  END IF;
END$$

CREATE TRIGGER date_affectation_mission
BEFORE UPDATE ON Effectuer_mission
FOR EACH ROW
BEGIN
  DECLARE d_debut DATE;
  DECLARE d_fin DATE;

  SELECT date_debut, date_fin INTO d_debut, d_fin
  FROM Mission
  WHERE id_mission = NEW.id_mission;

  IF NEW.date_affectation < d_debut 
     OR (d_fin IS NOT NULL AND NEW.date_affectation > d_fin) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Erreur : la date d’affectation doit être comprise dans la période de la mission.';
  END IF;
END$$


CREATE TRIGGER mission_type_contrat
BEFORE UPDATE ON Mission
FOR EACH ROW
BEGIN
    IF NEW.type_mission = 'EXTERNE' AND NEW.id_contrat IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur : Une mission EXTERNE doit avoir un contrat.';
    END IF;

    IF NEW.type_mission = 'INTERNE' AND NEW.id_contrat IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur : Une mission INTERNE ne doit pas avoir de contrat.';
    END IF;
END$$

DELIMITER ;