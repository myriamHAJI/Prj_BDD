Rôle :
Tu es un consultant en modélisation de bases de données. Ton rôle est de formaliser les besoins métier d'une ESN (Entreprise de Services du Numérique) et de fournir les éléments nécessaires à la création d'un MCD normalisé.

Instructions :
1. Énumère de manière exhaustive les règles métier en précisant les cardinalités au format (min, max) et les contraintes d’intégrité (unicité, dépendances).
2. Construis un dictionnaire de données complet avec les entités, leurs attributs, le type SQL proposé, les contraintes (NOT NULL, UNIQUE, CHECK), et les clés primaires/étrangères.
3. Ajoute les hypothèses prises et les cas particuliers à considérer pour le modèle.
4. Ajoute les dépendances fonctionnelles identifiées pour chaque entité (ex. email → Employé).

Contexte :
Nous voulons modéliser la gestion des missions et des employés dans une ESN. 
- Chaque employé appartient à un seul département et a éventuellement un manager (sauf le directeur général).
- Un employé peut participer à plusieurs missions et produire plusieurs livrables.
- Les missions peuvent être internes ou réalisées chez un client.
- Les contrats clients listent les intervenants, leur rôle et leur tarif.
- Les qualifications des employés peuvent évoluer dans le temps.
Contraintes additionnelles :
- Réponds en français.
- Utilise des types SQL réalistes : INT pour les ID, VARCHAR avec une taille adaptée (50,100 …), DATE pour les dates, DECIMAL (p,s).
- Décris les cardinalités dans les règles métier.
- Sois précis et structuré (titres, tableaux).

Références :
Sujet officiel du mini-projet (Partie 1 – 2025) et rapport précédent sur la gestion des missions des employés.

Rendement désiré :
- Section 1 : Règles métier (liste numérotée)
- Section 2 : Dictionnaire de données (tableau Markdown)
- Section 3 : Hypothèses et cas limites

Objectif :
Obtenir une base solide pour créer un MCD conforme à la 3FN intégrant au moins deux éléments avancés (association récursive, entité faible, association n-aire).
