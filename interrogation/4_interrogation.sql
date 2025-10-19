/* 
Scénario 1 : La responsable RH souhaite analyser les employés et leurs qualifications

Objectif : Suivre les employés, leur salaire, leur département et leurs compétences.
*/

use esn;

-- 1. Liste des employés appartenant à certains départements spécifiques
SELECT e.id_employe, e.nom, e.prenom, d.nom_departement
FROM employe e
JOIN departement d ON e.id_departement = d.id_departement
WHERE d.nom_departement IN ('Conseil & Stratégie IT', 'Support Technique', 'Commercial & Marketing')
ORDER BY d.nom_departement;

-- 2. Salaire moyen par département
SELECT d.nom_departement, ROUND(AVG(e.salaire),2) AS salaire_moyen
FROM employe e
JOIN departement d ON e.id_departement = d.id_departement
GROUP BY d.nom_departement
ORDER BY salaire_moyen DESC;

-- 3. Répartition des salaires par tranche
SELECT 
  CASE
    WHEN salaire < 4000 THEN ' Moins de 4000€'
    WHEN salaire BETWEEN 4000 AND 5000 THEN 'Entre 4000€ et 5000€'
    ELSE 'Plus de 5000€'
  END AS tranche_salaire,
  COUNT(*) AS nb_employes
FROM employe
GROUP BY tranche_salaire
ORDER BY tranche_salaire;

-- 4. Employés sans qualification
SELECT e.nom, e.prenom
FROM employe e
WHERE e.id_employe NOT IN (
  SELECT id_employe FROM posseder_qualification
);

-- 5. Répartition des qualifications
SELECT q.nom_qualification, COUNT(*) AS nb_employes
FROM posseder_qualification pq
JOIN qualification q ON pq.id_qualification = q.id_qualification
GROUP BY q.nom_qualification
ORDER BY nb_employes DESC;

-- 6. Nombre de missions par employé
SELECT e.id_employe, e.nom, e.prenom, COUNT(em.id_mission) AS nb_missions
FROM employe e
LEFT JOIN effectuer_mission em ON e.id_employe = em.id_employe
GROUP BY e.id_employe, e.nom, e.prenom
ORDER BY nb_missions DESC;

-- 7. Employés possédant les qualifications "Java" et "Big Data"
SELECT DISTINCT e.id_employe, e.nom, e.prenom, q.nom_qualification
FROM employe e
JOIN possession_qualification pq ON e.id_employe = pq.id_employe
JOIN qualification q ON pq.id_qualification = q.id_qualification
WHERE q.nom_qualification IN ('Développeur FullStack Java', 'Analyse Big Data')
ORDER BY e.nom;

-- 8. Nombre d’employés supervisés par chaque manager
SELECT m.id_employe AS id_manager,
    CONCAT(m.prenom, ' ', m.nom) AS manager,
    (
        SELECT COUNT(*)
        FROM employe e
        WHERE e.id_manager = m.id_employe
    ) AS nb_employes
FROM employe m
WHERE m.id_employe IN (SELECT DISTINCT id_manager FROM employe WHERE id_manager IS NOT NULL)
ORDER BY nb_employes DESC;

/* 
Scénario 2 : Le responsable commercial analyse les données des clients et de leurs contrats

Objectif : Mesurer l’activité des clients (contrats, types d’échanges, etc.).
*/

-- 9. Clients avec le nombre de contrats signés
SELECT c.nom_client, COUNT(co.id_contrat) AS nb_contrats
FROM client c
LEFT JOIN contrat co ON c.id_client = co.id_client
GROUP BY c.nom_client
ORDER BY nb_contrats DESC;

-- 10. Bilan des clients ayant signé un contrat entre 2022 et 2024
SELECT c.nom_client, COUNT(co.id_contrat) AS nb_contrats
FROM client c 
JOIN contrat co ON c.id_client = co.id_client
WHERE co.date_signature BETWEEN '2022-01-01' AND '2024-12-31'
GROUP BY c.nom_client;

-- 11. Types et nombre d’échanges effectués par l’entreprise
SELECT type_echange, COUNT(*) AS nb_echanges
FROM echanger
GROUP BY type_echange;

-- 12. Clients n’ayant eu aucun échange avec l’entreprise
SELECT c.nom_client
FROM client c
WHERE NOT EXISTS (
  SELECT 1
  FROM echanger e
  WHERE e.id_client = c.id_client
);

-- 13. Liste des clients n'ayant pas renouvlé de contrat ces 12 derniers mois

SELECT c.id_client, c.nom_client, co.date_signature AS derniere_signature
FROM client c
JOIN contrat co ON co.id_client = c.id_client
WHERE NOT EXISTS (
  SELECT 1
  FROM contrat co2
  WHERE co2.id_client = co.id_client
    AND co2.date_signature > co.date_signature
)
AND co.date_signature < DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
ORDER BY co.date_signature ASC;

-- 14 Liste des clients ayant eu au moins un échanges avec l'entreprise, sans contrat signé

SELECT c.id_client, c.nom_client, COUNT(DISTINCT e.type_echange) AS nb_canaux
FROM client c
JOIN echanger e ON e.id_client = c.id_client
WHERE c.id_client NOT IN (
  SELECT co.id_client FROM contrat co
)
GROUP BY c.id_client, c.nom_client
HAVING COUNT(DISTINCT e.type_echange) >= 1
ORDER BY nb_canaux DESC, c.nom_client;

-- 15 Employés qui n'échangent qu'avec des clients qui signent

SELECT e.nom, e.prenom
FROM employe e
WHERE NOT EXISTS (
    SELECT c_sans_contrat.id_client
    FROM client c_sans_contrat
    WHERE c_sans_contrat.id_client NOT IN (SELECT id_client FROM contrat) 
      AND EXISTS (
          SELECT 1
          FROM echanger ec
          WHERE ec.id_employe = e.id_employe
            AND ec.id_client = c_sans_contrat.id_client
      )
);

