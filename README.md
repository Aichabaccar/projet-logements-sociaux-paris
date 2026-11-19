# Logements sociaux à Paris (2001-2025) : combien, où, et qui ?

Projet de data visualisation sur des données ouvertes (open data) : analyse des logements sociaux agréés à Paris entre 2001 et 2025.

## Problématique

La production de logements sociaux à Paris est-elle régulière et répartie, ou concentrée dans le temps, dans l'espace et entre quelques bailleurs ?

## Données

- **Source** : https://www.data.gouv.fr/datasets/programmes-de-logements-sociaux-finances-a-paris
- **Contenu** : 4 293 lignes et 18 colonnes, une ligne par financement de programme (adresse, arrondissement, année d'agrément, bailleur, mode de réalisation, nature du programme, nombre de logements par type de financement, coordonnées géographiques).
- **Volume** : 130 471 logements agréés, 72 bailleurs, années 2001 à 2025.
- **Fichier du dépôt** : `data/logements_sociaux_paris_clean.csv`

## Outils

- **Navicat** (MySQL) : création de la base, import, normalisation et requêtes d'analyse.
- **Tableau Desktop** : tableaux de bord et présentation.

## Méthode

1. **Import** du CSV dans une table de travail `stg_logements` (assistant d'importation de Navicat).
2. **Normalisation** : tables `bailleur` (72), `nature_programme` (13), `mode_realisation` (3) et table de faits `financement` (4 293 lignes), reliées par des clés étrangères. La vue `v_financement` regroupe le tout pour Tableau.
3. **Contrôles** : 4 293 lignes, 130 471 logements, 72 bailleurs, années 2001-2025, et cohérence entre le total et la somme des quatre types de financement.
4. **Analyses SQL** : requêtes organisées par tableau de bord dans `sql/analyses.sql`.
5. **Visualisation** : connexion de Tableau à la vue `v_financement` en extraction, puis construction des tableaux de bord.

### Choix et difficultés rencontrées

- Certains identifiants de programme contiennent des lettres (par exemple `CPE12`) : la colonne `id_livraison` est donc stockée en texte (`VARCHAR`) et non en entier.
- Plusieurs lignes peuvent partager le même `id_livraison` : la clé primaire de `financement` est un identifiant auto-incrémenté (`id_financement`).
- Les lignes de correction comptable (valeurs négatives) sont conservées, car elles rendent le total exact.
- Le bailleur « NON RENSEIGNE » (109 programmes) est conservé dans la base, mais exclu des classements de bailleurs.

## Tableaux de bord

| # | Question | Contenu principal |
|---|---|---|
| 1 | **Combien, et à quel rythme ?** | Chiffres clés, logements agréés par année avec moyenne mobile, cumul, top des bailleurs, nature de programme, mode de réalisation |
| 2 | **Où ?** | Carte des programmes, carte de densité, logements par arrondissement, comparaison Nord-Est / reste de Paris |
| 3 | **Qui ?** | Top des bailleurs, taille et nombre de programmes, mix de financement, rythme des cinq premiers bailleurs, présence par arrondissement |
| 4 | [à compléter] | [à compléter] |

![Tableau de bord 1](captures/dashboard_1.png)
![Tableau de bord 2](captures/dashboard_2.png)
![Tableau de bord 3](captures/dashboard_3.png)
![Tableau de bord 4](captures/dashboard_4.png)

## Principaux résultats

- 130 471 logements agréés, sur 4 293 programmes et 72 bailleurs (30 logements par programme en moyenne).
- Rythme irrégulier : 4 927 logements par an en moyenne sur 2001-2010, 6 384 sur 2011-2020, pic en 2016 (7 502), puis baisse à 2 908 en 2020 et 2 657 en 2024.
- Cinq arrondissements (13e, 20e, 15e, 18e, 19e) concentrent 54 % des logements. Le Nord-Est de Paris (10e, 11e, 18e, 19e, 20e) en rassemble 40 %, le centre (1er au 4e) 3,7 %.
- Paris Habitat, RIVP et Elogie-Siemp produisent environ 68 % du total ; les dix premiers bailleurs environ 87 %.

## Limites

- Les données décrivent des **agréments par année** (un flux), et non l'évolution du parc de logements sociaux.
- Environ 2,5 % des logements n'ont pas de bailleur renseigné.
- Deux lignes sont des corrections comptables (une avec un total négatif).
- Le jeu de données ne contient ni population ni revenus : l'analyse décrit la production, mais ne mesure pas les besoins.

## Structure du dépôt

```
├── README.md
├── data/                  données et provenance
├── sql/
│   ├── creation_base.sql  création de la base, des tables et de la vue
│   └── analyses.sql       requêtes de contrôle et d'analyse
├── visualisation/
│   └── projet.twbx        classeur Tableau (données embarquées)
├── captures/              captures des tableaux de bord
└── presentation/
    └── presentation.pdf   support de présentation
```

## Reproduire le projet

1. Créer la base `bdd_logements` dans MySQL (via Navicat).
2. Importer `data/logements_sociaux_paris_clean.csv` dans une table nommée `stg_logements` (assistant d'importation de Navicat, première ligne = en-têtes).
3. Exécuter `sql/creation_base.sql` : création des tables `bailleur`, `nature_programme`, `mode_realisation`, `financement` et de la vue `v_financement`.
4. Exécuter `sql/analyses.sql` pour retrouver les chiffres de contrôle.
5. Ouvrir `visualisation/projet.twbx` dans Tableau (les données sont embarquées, aucune connexion à la base n'est nécessaire).
