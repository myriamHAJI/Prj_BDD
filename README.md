# Mini-Projet BDD - Gestion d'une ESN (Partie 1 : Conception)

Ce dépôt contient la **première partie** du mini-projet de base de données : la **conception** d'un système d'information pour une **ESN** (Entreprise de Services Numériques).  
L'objectif est de modéliser la gestion des employés, départements, clients, missions, contrats et livrables, ainsi que les hiérarchies et interventions.

---

## Objectifs pédagogiques
- Identifier et formaliser les **règles métier** à partir d'un cahier des charges.  
- Concevoir un **Modèle Conceptuel de Données (MCD)** clair et normalisé.  
- Construire un **dictionnaire de données cohérent**.  
- Préparer la transition vers la **Partie 2 (implémentation SQL)**.  

---

## Contenu du dépôt
- `MCD/` : schéma conceptuel (`MCD.png`) et fichier source (`MCD.loo`) ouvrable avec **Looping**.  
- `prompts/` : contient le prompt RICARDO utilisé ainsi que la réponse de l’IA (règles métier, dictionnaire de données et hypothèses).  
- `rapport/` : rapport de conception (au format DOCX).  

---

## Règles métier

Après analyse des propositions initiales fournies par l’IA, nous avons réétudié et précisé les règles métier afin de les traduire correctement dans le MCD final.  

### Employés et départements
- Un employé appartient obligatoirement à **un département** (1,1).  
- Un département emploie **(0,n)** employés.  

### Hiérarchie des employés
- Un employé peut avoir **(0,1)** manager.  
- Un employé peut manager **(0,n)** subordonnés.  
- Contrainte : un employé ne peut pas être son propre manager.  

### Qualifications
- Un employé peut posséder **(0,n)** qualifications.  
- Une qualification peut être détenue par **(0,n)** employés.  
- Chaque possession de qualification est associée à une **date d’obtention** et une **date d’expiration**.  

### Clients et échanges
- Un client peut échanger **(1,n)** fois avec l’ESN (par l’intermédiaire d’un employé).  
- Un employé peut participer à **(0,n)** échanges.  
- Chaque échange est identifié par une **date**.  

### Contrats
- Un client peut signer **(0,n)** contrats.  
- Un contrat est toujours signé par **un seul client** (1,1).  
- Chaque contrat possède une **date de signature**, une **date de début** et une **date de fin**.  

### Missions
- Un contrat couvre **(1,n)** missions.  
- Une mission appartient toujours à **un seul contrat** (1,1).  
- Une mission est caractérisée par : `id_mission`, `nom_mission`, `type_mission`, `date_debut`, `date_fin`.  

### Affectations
- Un employé peut être affecté à **(0,n)** contrats.  
- Un contrat implique **(1,n)** employés.  

### Participation aux missions
- Un employé peut effectuer **(0,n)** missions.  
- Une mission implique **(1,n)** employés.  

### Livrables
- Une mission peut produire **(0,n)** livrables.  
- Un livrable est toujours rattaché à **une seule mission** (1,1).  
- Un livrable est défini par : `numero`, `description`, `date_remise`.  

### Rédaction
- Un employé peut rédiger **(0,n)** livrables.  
- Un livrable est toujours rédigé par **un seul employé** (1,1).  

---

## Contraintes d'intégrité globales
Certaines règles métier ne figurent pas directement dans le MCD mais doivent être respectées dans l’implémentation :  

- Le salaire d’un employé doit être strictement supérieur à 0.  
- Le tarif journalier d’une affectation doit être strictement supérieur à 0.  
- La date de fin d’une **mission** doit être supérieure ou égale à sa date de début (ou `NULL` si mission en cours).  
- La date de fin d’un **contrat** doit être supérieure ou égale à sa date de début (ou `NULL` si contrat en cours).  
- La date d’expiration d’une **qualification possédée** doit être supérieure ou égale à sa date d’obtention (ou `NULL` si qualification en cours).  
- Un employé ne peut pas être son propre manager.  
- Les livrables d’une mission sont numérotés à partir de 1, avec une numérotation locale par mission.  
- La **commission** (si utilisée) doit être supérieure ou égale à 0.  
- Chaque mission doit comporter au moins **un employé** (participation minimale côté Mission sur `Effectuer_mission`).  
- L’attribut `type_mission` est conservé uniquement comme **classification interne** des missions. Les règles “INTERNE ⇒ contrat NULL / CLIENT ⇒ contrat NOT NULL” proposées par l’IA ne s’appliquent plus, car toutes les missions sont contractualisées.  

---

## Modèle conceptuel (MCD)
Le MCD a été réalisé avec **Looping** et est fourni en deux formats :  
- `MCD.png` : export graphique pour consultation rapide.  
- `MCD.loo` : fichier source éditable.  

---

## Perspectives (Partie 2)
La deuxième partie du projet consistera à :  
1. Transformer le **MCD en MLD/MPD**.  
2. **Implémenter le modèle en SQL** (création de tables, contraintes, données de test).  
3. Définir un ensemble de **requêtes SQL** pour valider le schéma et extraire des informations utiles.  

## Contenu du dépôt
- `models/` : l'ensemble des schémas conceptuels (`MCD/MCD.png`,`MLD/MLD.png`,`MPD/MPD.png`) et le fichier source (`MCD.loo`) ouvrable avec **Looping**.  
- `prompts/` : contient le prompt RICARDO utilisé, la réponse de l’IA (règles métier, dictionnaire de données et hypothèses) et le prompt d'insertion de données.  
- `rapport/` : rapport de conception (au format DOCX) ainsi que la video en MP4.
- `insertion/` : fichier d'insertion de données, genere par l'IA.
- `interrogation` : fichier de test des requetes dans notre base de données ainsi qu'un fichier comportant les scenarios d'utilisations.

---

## Auteurs
- **Myriam HAJI** - EFREI Paris  
- **Omar KAMOUN** - EFREI Paris  
