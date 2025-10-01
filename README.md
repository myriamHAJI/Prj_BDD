Mini-Projet BDD — Gestion d’une ESN (Partie 1 : Conception)

Ce dépôt contient la première partie du mini-projet de base de données : la conception d’un système d’information pour une ESN (Entreprise de Services Numériques).
L’objectif est de modéliser la gestion des employés, départements, clients, missions, contrats et livrables, ainsi que les hiérarchies et interventions.

Objectifs pédagogiques

Identifier et formaliser les règles métier à partir d’un cahier des charges.

Concevoir un Modèle Conceptuel de Données (MCD) clair et normalisé.

Construire un dictionnaire de données cohérent.

Préparer la transition vers la Partie 2 (implémentation SQL).

Contenu du dépôt

MCD/ : schéma conceptuel (MCD.png) et fichier source (MCD.loo) ouvrable avec Looping.

prompts/ : documents de travail préparatoires (règles métier, réflexion).

rapport/ : rapport de conception (au format DOCX).

Règles métier

Les règles métier ci-dessous définissent le fonctionnement du système et justifient les choix de modélisation du MCD.

Départements et employés

Un département emploie (0,n) employés.

Un employé appartient obligatoirement à un seul département (1,1).

Hiérarchie des employés

Un employé peut avoir (0,1) manager.

Un employé peut manager (0,n) subordonnés.

Contrainte : un employé ne peut pas être son propre manager.

Missions

Une mission peut être interne (réalisée pour l’ESN) ou externe (réalisée pour un client).

Une mission implique au minimum un employé.

Clients et contrats

Un client possède (0,n) contrats.

Une mission externe est rattachée à un contrat actif d’un client.

Interventions

Une intervention associe un employé, une mission et un contrat.

Le triplet (employé, mission, contrat) est unique.

Chaque intervention précise un rôle et un tarif journalier strictement positif.

Livrables

Une mission peut produire (0,n) livrables.

Chaque livrable est identifié par un nom, une date prévue, une date réelle et un statut.

Modèle conceptuel (MCD)

Le MCD a été réalisé avec Looping et est fourni en deux formats :

MCD.png : export graphique pour consultation rapide.

MCD.loo : fichier source éditable.

Aperçu :


Perspectives (Partie 2)

La seconde partie du projet consistera à :

Transformer le MCD en MLD/MPD.

Implémenter le modèle en SQL (création de tables, contraintes, données de test).

Définir un ensemble de requêtes pour valider le schéma et extraire des informations utiles.

Auteurs

Myriam HAJI — EFREI Paris

Omar KAMOUN — EFREI Paris