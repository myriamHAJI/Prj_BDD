1) Règles métier (cardinalités au format (min,max))

Département–Employé

Un département emploie (0,n) employés.

Un employé appartient à exactement (1,1) département.

Hiérarchie (récursive Employé–Employé)

Un employé peut avoir (0,1) manager (qui est un employé).

Un employé peut manager (0,n) subordonnés.

Contrainte : un employé ne peut pas se manager lui-même.

Employé–Mission (affectations)

Un employé peut participer à (0,n) missions.

Une mission implique (1,n) employés (au moins un).

Mission–Client (type de mission)

Une mission a un type ∈ {INTERNE, CLIENT}.

Si CLIENT, la mission est réalisée pour (1,1) client.

Si INTERNE, la mission n’a pas de client (0,0).

Contrat–Client–Mission

Un client signe (0,n) contrats.

Un contrat peut couvrir (1,n) missions chez ce même client.

Une mission externe est rattachée (1,1) à un contrat actif du client concerné.

Intervention (association n-aire)

Une intervention lie (1,1) contrat, (1,1) employé, (1,1) mission.

Chaque tuple (contrat, employé, mission) est unique.

L’intervention précise le rôle de l’employé et son tarif_jour au titre du contrat (tarif > 0).

Mission–Livrable (entité faible)

Une mission produit (0,n) livrables.

Un livrable est identifié par la mission + un numéro (entité faible).

La numérotation des livrables redémarre à 1 pour chaque mission.

Employé–Qualification (historisation)

Un employé possède (0,n) qualifications au cours du temps.

Une qualification peut être détenue par (0,n) employés.

L’historique est tracé par (date_obtention, date_expiration?).

Contraintes de cohérence générales

Salaire employé > 0.

date_fin_mission ≥ date_debut_mission (ou NULL si en cours).

date_expiration_qualification ≥ date_obtention (ou NULL).

Le client d’une mission CLIENT = le client du contrat rattaché.

Le manager d’un employé doit appartenir à un (éventuellement autre) département valide; pas de cycles hiérarchiques (règle métier/contrôle applicatif).

2) Dictionnaire de données (entités, attributs, types, contraintes)

Abréviations : PK = Primary Key, FK = Foreign Key

Employe
Attribut	Type	Null	Contraintes	Description
id_employe	INT	NOT NULL	PK	Identifiant
nom	VARCHAR(50)	NOT NULL		Nom
prenom	VARCHAR(50)	NOT NULL		Prénom
email	VARCHAR(100)	NOT NULL	UNIQUE	email pro
salaire	DECIMAL(10,2)	NOT NULL	CHECK (salaire > 0)	Salaire mensuel
id_departement	INT	NOT NULL	FK → Departement(id_departement)	Appartenance
id_manager	INT	NULL	FK → Employe(id_employe), CHECK (id_manager <> id_employe)	Manager (récursif)
Departement
Attribut	Type	Null	Contraintes	Description
id_departement	INT	NOT NULL	PK	Identifiant
nom_departement	VARCHAR(50)	NOT NULL	UNIQUE	Nom du département
Client
Attribut	Type	Null	Contraintes	Description
id_client	INT	NOT NULL	PK	Identifiant
nom_client	VARCHAR(100)	NOT NULL	UNIQUE	Raison sociale
email_contact	VARCHAR(100)	NULL		Contact
telephone	VARCHAR(20)	NULL		
Contrat
Attribut	Type	Null	Contraintes	Description
id_contrat	INT	NOT NULL	PK	Identifiant
id_client	INT	NOT NULL	FK → Client(id_client)	Client signataire
date_signature	DATE	NOT NULL		Date de signature
date_debut	DATE	NOT NULL		Début de validité
date_fin	DATE	NULL	CHECK (date_fin IS NULL OR date_fin >= date_debut)	Fin de validité
Mission
Attribut	Type	Null	Contraintes	Description
id_mission	INT	NOT NULL	PK	Identifiant
nom_mission	VARCHAR(100)	NOT NULL		Libellé
type_mission	VARCHAR(10)	NOT NULL	CHECK (type_mission IN ('INTERNE','CLIENT'))	Nature
id_client	INT	NULL	FK → Client(id_client) (NULL si INTERNE)	Client concerné
id_contrat	INT	NULL	FK → Contrat(id_contrat) (obligatoire si CLIENT)	Contrat associé
date_debut	DATE	NOT NULL		Début
date_fin	DATE	NULL	CHECK (date_fin IS NULL OR date_fin >= date_debut)	Fin

Règle d’intégrité (métier) :

Si type_mission='CLIENT' alors id_client NOT NULL et id_contrat NOT NULL et Contrat.id_client = Mission.id_client.

Si type_mission='INTERNE' alors id_client NULL et id_contrat NULL.
(Contrôle applicatif / trigger recommandé si non exprimable en CHECK standard.)

Intervention (association n-aire Contrat–Employe–Mission)
Attribut	Type	Null	Contraintes	Description
id_contrat	INT	NOT NULL	FK → Contrat(id_contrat)	Contrat
id_employe	INT	NOT NULL	FK → Employe(id_employe)	Intervenant
id_mission	INT	NOT NULL	FK → Mission(id_mission)	Mission
role	VARCHAR(50)	NOT NULL		Rôle sur la mission
tarif_jour	DECIMAL(10,2)	NOT NULL	CHECK (tarif_jour > 0)	TJM
PK composite			(id_contrat, id_employe, id_mission)	Unicité du triplet
Livrable (entité faible de Mission)
Attribut	Type	Null	Contraintes	Description
id_mission	INT	NOT NULL	FK → Mission(id_mission)	Mission mère
numero	INT	NOT NULL	CHECK (numero >= 1)	Numéro (par mission)
description	VARCHAR(255)	NOT NULL		
date_remise	DATE	NOT NULL		
PK composite			(id_mission, numero)	Identité locale
Qualification
Attribut	Type	Null	Contraintes	Description
id_qualification	INT	NOT NULL	PK	Identifiant
nom_qualification	VARCHAR(50)	NOT NULL	UNIQUE	Intitulé
niveau	VARCHAR(20)	NOT NULL		(ex. Junior/Middle/Senior)
Posseder_Qualification (historisée)
Attribut	Type	Null	Contraintes	Description
id_employe	INT	NOT NULL	FK → Employe(id_employe)	Employé
id_qualification	INT	NOT NULL	FK → Qualification(id_qualification)	Qualification
date_obtention	DATE	NOT NULL		Début de validité
date_expiration	DATE	NULL	CHECK (date_expiration IS NULL OR date_expiration >= date_obtention)	Fin de validité
PK composite			(id_employe, id_qualification, date_obtention)	Historisation
3) Hypothèses & cas limites

Hiérarchie : la direction générale peut ne pas avoir de manager. Les boucles hiérarchiques sont interdites (contrôle applicatif).

Missions internes : pas de client ni de contrat.

Missions client : le contrat et le client sont cohérents entre eux et cohérents avec la mission.

Interventions : un même employé peut intervenir plusieurs fois sur des missions différentes du même contrat (unicité assurée par le triplet).

Livrables : la numérotation est locale à la mission (redémarre à 1).

Qualifications : on conserve l’historique complet ; l’absence de date_expiration = qualification encore valide.

Suppression en cascade :

Supprimer une mission supprime ses livrables et ses interventions associées (ON DELETE CASCADE recommandé).

Supprimer un employé supprime ses interventions et ses possessions de qualifications (ON DELETE CASCADE recommandé).

Pour le manager, préférer ON DELETE SET NULL sur id_manager.

4) Dépendances fonctionnelles (DF) par entité

Objectif : justifier la 3FN et les clés.

Employe

id_employe → nom, prenom, email, salaire, id_departement, id_manager

email → id_employe (candidature/unique)

Aucune DF partielle/normale violée (PK simple).

Departement

id_departement → nom_departement

nom_departement → id_departement (unique)

Client

id_client → nom_client, email_contact, telephone

nom_client → id_client (assimilé unique dans le modèle ; si ce n’est pas souhaité, on retire l’unicité)

Contrat

id_contrat → id_client, date_signature, date_debut, date_fin

(id_client ne détermine pas id_contrat → un client peut avoir plusieurs contrats)

Mission

id_mission → nom_mission, type_mission, id_client, id_contrat, date_debut, date_fin

Contrainte inter-entités (non DF stricte) : si type_mission='CLIENT' alors id_client et id_contrat non nuls et compatibles.

Intervention (PK composite)

(id_contrat, id_employe, id_mission) → role, tarif_jour

Aucune sous-clé ne détermine seule role ni tarif_jour → pas de DF partielle.

Livrable (PK composite)

(id_mission, numero) → description, date_remise

numero seul ne suffit pas (numérotation locale) → pas de DF partielle.

Qualification

id_qualification → nom_qualification, niveau

nom_qualification → id_qualification (unique)

Posseder_Qualification (historisée, PK composite)

(id_employe, id_qualification, date_obtention) → date_expiration

Pas de DF partielle (les trois attributs identifient l’occurrence).