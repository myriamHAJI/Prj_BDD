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
- `prompts/` : documents de travail préparatoires (règles métier, réflexion).  
- `rapport/` : rapport de conception (au format DOCX).  

---

## Règles métier

### Départements et employés
- Un département emploie **(0,n)** employés.  
- Un employé appartient obligatoirement à **un seul département (1,1)**.  

### Hiérarchie des employés
- Un employé peut avoir **(0,1)** manager.  
- Un employé peut manager **(0,n)** subordonnés.  
- **Contrainte** : un employé ne peut pas être son propre manager.  

### Missions
- Une mission peut être **interne** (réalisée pour l'ESN) ou **externe** (réalisée pour un client).  
- Une mission implique au minimum **un employé**.  

### Clients et contrats
- Un client possède **(0,n)** contrats.  
- Une mission externe est rattachée à un **contrat actif** d'un client.  

### Interventions
- Une intervention associe un **employé**, une **mission** et un **contrat**.  
- Le triplet `(employé, mission, contrat)` est **unique**.  
- Chaque intervention précise un **rôle** et un **tarif journalier strictement positif**.  

### Livrables
- Une mission peut produire **(0,n)** livrables.  
- Chaque livrable est identifié par un **nom**, une **date prévue**, une **date réelle** et un **statut**.  

---

## Contraintes d'intégrité globales
Certaines règles métier ne figurent pas directement dans le MCD mais doivent être respectées dans l’implémentation :  

- Le salaire d’un employé doit être strictement supérieur à 0.  
- Le tarif journalier d’une affectation doit être strictement supérieur à 0.  
- La date de fin d’une mission ou d’un contrat doit être postérieure ou égale à la date de début (ou nulle si en cours).  
- Un employé ne peut pas être son propre manager.  
- Les livrables d’une mission sont numérotés à partir de 1, avec une numérotation locale par mission.  

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

---

## Auteurs
- **Myriam HAJI** - EFREI Paris  
- **Omar KAMOUN** - EFREI Paris  
