-- 1. Chiffres clés
SELECT COUNT(*) AS nb_lignes,
       SUM(nb_total) AS nb_logements,
       COUNT(DISTINCT id_bailleur) AS nb_bailleurs,
       MIN(annee_agrement) AS annee_min,
       MAX(annee_agrement) AS annee_max
FROM financement;

-- 2. Logements par arrondissement
SELECT arrondissement, COUNT(*) AS nb_programmes, SUM(nb_total) AS nb_logements
FROM financement
GROUP BY arrondissement
ORDER BY nb_logements DESC;

-- 3. Top 10 des bailleurs
SELECT nom_bailleur, SUM(nb_total) AS nb_logements
FROM v_financement
GROUP BY nom_bailleur
ORDER BY nb_logements DESC
LIMIT 10;

-- 4. Répartition par type de financement
SELECT SUM(nb_pla_i) AS PLA_I, SUM(nb_plus) AS PLUS,
       SUM(nb_plus_cd) AS PLUS_CD, SUM(nb_pls) AS PLS
FROM financement;

-- 5. Logements agréés par année
SELECT annee_agrement, SUM(nb_total) AS nb_logements
FROM financement
GROUP BY annee_agrement
ORDER BY annee_agrement;

-- 6. Mode de réalisation
SELECT libelle_mode, SUM(nb_total) AS nb_logements
FROM v_financement
GROUP BY libelle_mode;

-- 7. Nature de programme
SELECT libelle_nature, SUM(nb_total) AS nb_logements
FROM v_financement
GROUP BY libelle_nature
ORDER BY nb_logements DESC;

-- 8. Contrôle qualité : lignes atypiques
SELECT COUNT(*) AS nb_negatifs FROM financement WHERE nb_total <= 0;
SELECT COUNT(*) AS nb_corrections FROM financement WHERE est_correction = 1;