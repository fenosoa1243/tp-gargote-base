1-
categorie (__id__, libelle)
plat (__id__, nom, prix, #id_categorie)
commande (__id__, date_commande, numero_table)
commande_ligne(__id__, #id_commande, #id_plat, quantite, prix_unitaire)

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

5-
La requête b crée un nouveau plat, « Mofo gasy ».
Le code attendu est 201 Created, car une nouvelle ressource a été créée avec succès.
Pourquoi pas 200 OK ? Le code 200 indique généralement que la requête a réussi, tandis que 201 précise qu’une nouvelle ressource a été créée.

6-

7-
curl -X POST http://localhost:8080/api/commandes \
     -H "Content-Type: application/json" \
     -d '{
           "numero_table": 6,
           "lignes": [
             {
               "id_plat": 1,
               "quantite": 2
             },
             {
               "id_plat": 2,
               "quantite": 1
             }
           ]
         }'

