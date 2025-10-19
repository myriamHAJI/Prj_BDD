CREATE DATABASE esn;

USE esn;

CREATE TABLE Departement (
   id_departement INT AUTO_INCREMENT PRIMARY KEY,
   nom_departement VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Employe (
   id_employe INT AUTO_INCREMENT PRIMARY KEY,
   nom VARCHAR(50) NOT NULL,
   prenom VARCHAR(50) NOT NULL,
   email VARCHAR(100) UNIQUE NOT NULL,
   job VARCHAR(50) NOT NULL,
   date_embauche DATE NOT NULL,
   salaire DECIMAL(10,2),
   commission DECIMAL(10,2),
   id_departement INT NOT NULL,
   id_manager INT,
   FOREIGN KEY (id_departement) REFERENCES Departement(id_departement),
   FOREIGN KEY (id_manager) REFERENCES Employe(id_employe)
);

CREATE TABLE Client (
   id_client INT AUTO_INCREMENT PRIMARY KEY,
   nom_client VARCHAR(100) NOT NULL,
   email_contact VARCHAR(100) UNIQUE NOT NULL,
   telephone VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Contrat (
   id_contrat INT AUTO_INCREMENT PRIMARY KEY,
   date_signature DATE NOT NULL,
   date_debut DATE NOT NULL,
   date_fin DATE,
   id_employe INT NOT NULL,
   id_client INT NOT NULL,
   FOREIGN KEY (id_employe) REFERENCES Employe(id_employe),
   FOREIGN KEY (id_client) REFERENCES Client(id_client)
);

CREATE TABLE Qualification (
   id_qualification INT AUTO_INCREMENT PRIMARY KEY,
   nom_qualification VARCHAR(50) UNIQUE NOT NULL,
   niveau ENUM ('Expert', 'Senior', 'Confirmé', 'Junior') NOT NULL,
   description_qualification VARCHAR(500)
);

CREATE TABLE Mission (
   id_mission INT AUTO_INCREMENT PRIMARY KEY,
   nom_mission VARCHAR(100) NOT NULL,
   type_mission ENUM('INTERNE','EXTERNE') NOT NULL,
   date_debut DATE NOT NULL,
   date_fin DATE,
   id_contrat INT,
   FOREIGN KEY (id_contrat) REFERENCES Contrat(id_contrat)
);

CREATE TABLE Livrable (
   id_mission INT NOT NULL,
   numero INT NOT NULL,
   description VARCHAR(200) NOT NULL,
   date_remise DATE NOT NULL,
   PRIMARY KEY (id_mission, numero),
   FOREIGN KEY (id_mission) REFERENCES Mission(id_mission)
);

CREATE TABLE Possession_qualification  (
   id_employe INT NOT NULL,
   id_qualification INT NOT NULL,
   date_obtention DATE NOT NULL,
   date_expiration DATE,
   PRIMARY KEY (id_employe, id_qualification, date_obtention),
   FOREIGN KEY (id_employe) REFERENCES Employe(id_employe),
   FOREIGN KEY (id_qualification) REFERENCES Qualification(id_qualification)
);

CREATE TABLE Effectuer_mission (
   id_employe INT NOT NULL,
   id_mission INT NOT NULL,
   date_affectation DATE DEFAULT (CURRENT_DATE),
   PRIMARY KEY (id_employe, id_mission),
   FOREIGN KEY (id_employe) REFERENCES Employe(id_employe),
   FOREIGN KEY (id_mission) REFERENCES Mission(id_mission)
);

CREATE TABLE Echanger (
   id_employe INT NOT NULL,
   id_client INT NOT NULL,
   date_echange DATE NOT NULL DEFAULT (CURRENT_DATE),
   type_echange ENUM ('TELEPHONE', 'VISIO', 'EMAIL', 'MESSAGE', 'EN_PERSONNE'),
   PRIMARY KEY (id_employe, id_client, date_echange),
   FOREIGN KEY (id_employe) REFERENCES Employe(id_employe),
   FOREIGN KEY (id_client) REFERENCES Client(id_client)
);

CREATE TABLE Rediger (
   id_employe INT NOT NULL,
   id_mission INT NOT NULL,
   numero INT NOT NULL,
   date_redaction DATE NOT NULL DEFAULT (CURRENT_DATE),
   statut ENUM ('EN_COURS', 'TERMINE'),
   PRIMARY KEY (id_employe, id_mission, numero),
   FOREIGN KEY (id_employe) REFERENCES Employe(id_employe),
   FOREIGN KEY (id_mission, numero) REFERENCES Livrable(id_mission, numero)
);
