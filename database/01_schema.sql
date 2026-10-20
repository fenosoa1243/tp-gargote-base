-- =============================================================
--  Gargote — schéma de base (version fournie, NIVEAU 0)
--  SGBD : PostgreSQL
--  Exécution : psql -U gargote -d gargote -f 01_schema.sql

-- psql -U gargote -W -d gargote
--mot de passe : gargote
-- =============================================================

DROP TABLE IF EXISTS commande_ligne CASCADE;
DROP TABLE IF EXISTS commande       CASCADE;
DROP TABLE IF EXISTS plat           CASCADE;
DROP TABLE IF EXISTS categorie      CASCADE;

-- Catégories du menu : Plat, Soupe, Boisson...
CREATE TABLE categorie (
    id       SERIAL PRIMARY KEY,
    libelle  VARCHAR(50) NOT NULL UNIQUE
);

-- Plats proposés à la carte (prix en Ariary)
CREATE TABLE plat (
    id            SERIAL PRIMARY KEY,
    nom           VARCHAR(100) NOT NULL,
    prix          INTEGER      NOT NULL,
    id_categorie  INTEGER      NOT NULL REFERENCES categorie(id)
);

-- Une commande = une table de la gargote à un instant donné
CREATE TABLE commande (
    id             SERIAL PRIMARY KEY,
    date_commande  TIMESTAMP(0) NOT NULL DEFAULT now(),
    numero_table   INTEGER   NOT NULL
);

-- Les plats commandés.
-- prix_unitaire est COPIÉ depuis plat.prix au moment de la commande :
-- si le prix du plat change demain, les anciennes commandes restent justes.
CREATE TABLE commande_ligne (
    id             SERIAL PRIMARY KEY,
    id_commande    INTEGER NOT NULL REFERENCES commande(id) ON DELETE CASCADE,
    id_plat        INTEGER NOT NULL REFERENCES plat(id),
    quantite       INTEGER NOT NULL,
    prix_unitaire  INTEGER NOT NULL
);

/*
1-
categorie (**id**, libelle)
plat (**id**, nom, prix, #id_categorie)
commande (**id**, date_commande, numero_table)
commande_ligne(**id**, #id_commande, #id_plat, quantite, prix_unitaire)

2-
La table commande_ligne contient la colonne prix_unitaire pour conserver le prix du plat au moment où le client passe sa commande,
 même si le prix change plus tard dans la table plat.
Exemple concret : si un plat coûte 10 000 Ariary aujourd'hui et que le client le commande, le prix_unitaire sera enregistré comme 10 000 dans commande_ligne.
Si demain le prix du plat change à 12 000 Ariary, les anciennes commandes restent

3-
Lorsqu'on supprime une commande, les lignes correspondantes dans la table commande_ligne sont également supprimées automatiquement 
en raison de l'instruction ON DELETE CASCADE spécifiée dans la contrainte de clé étrangère.

4-
_Un prix négatif:Dans la table plat, la colonne prix accepte un nombre négatif; 
INSERT INTO plat (nom, prix, id_categorie) VALUES ('Riz', -5000, 1);
_Une quantité négative:Dans la table commande_ligne, la colonne quantite est NOT NULL, mais elle accepte zéro et les nombres négatifs;
INSERT INTO commande_ligne (id_commande, id_plat, quantite, prix_unitaire) VALUES (1, 1, -2, 5000);
_Un prix unitaire négatif:La colonne prix_unitaire de commande_ligne accepte également un prix négatif;
INSERT INTO commande_ligne (id_commande, id_plat, quantite, prix_unitaire) VALUES (1, 1, 2, -5000);

*/