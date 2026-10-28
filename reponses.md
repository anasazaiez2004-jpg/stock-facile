Le fichier .db contient les données réelles de l'utilisateur (qui changent constamment) et est un fichier binaire lourd. Le fichier schema.sql contient uniquement le "plan" de la base (la structure CREATE TABLE) sous forme de texte lisible, ce qui est indispensable pour que les autres développeurs puissent recréer la base sur leur machine sans télécharger de données inutiles.



Comment stocke-t-on disponible et date_ajout ? disponible est stocké comme un INTEGER (1 pour vrai, 0 pour faux) car SQLite n'a pas de type BOOLEAN. date_ajout est stocké comme TEXT au format ISO 8601 (AAAA-MM-JJTHH:MM:SS) car SQLite n'a pas de type DATETIME.

Rôle de AUTOINCREMENT ? Il génère automatiquement un identifiant unique incrémenté (1, 2, 3...) pour chaque nouvelle ligne.

Rôle de UNIQUE sur nom ? Il empêche d'avoir deux catégories avec exactement le même nom dans la base.

Rôle de CHECK (prix >= 0) ? Il s'agit d'une contrainte qui empêche d'insérer ou de modifier un produit avec un prix négatif.

Que signifie ON DELETE RESTRICT ? Cela empêche la suppression d'une catégorie si des produits y sont encore liés (pour éviter les produits orphelins).




Pourquoi écrit-on 'Huile d''olive' avec deux apostrophes ? -> Parce que l'apostrophe simple ' sert à délimiter le texte en SQL. Pour l'inclure à l'intérieur du texte, il faut la doubler ('').





L'exécution s'est terminée avec des erreurs.
Résultat : CHECK constraint failed: prix >= 0
À la ligne 1 :
-- a) prix négatif
INSERT INTO produits (nom, prix, quantite, date_ajout, categorie_id)
VALUES ('Test prix', -5, 1, '2026-10-05T08:00:00', 1);



L'exécution s'est terminée avec des erreurs.
Résultat : FOREIGN KEY constraint failed
À la ligne 1 :
-- b) catégorie qui n'existe pas
INSERT INTO produits (nom, prix, quantite, date_ajout, categorie_id)
VALUES ('Test catégorie', 1, 1, '2026-10-05T08:00:00', 99);




L'exécution s'est terminée avec des erreurs.
Résultat : FOREIGN KEY constraint failed
À la ligne 1 :
-- c) supprimer une catégorie qui contient des produits
DELETE FROM categories WHERE id = 1;




Q1.7 : Le fichier schema.sql contient les instructions SQL CREATE TABLE permettant de recréer la structure de la base à l'identique.
Q1.8 : Il est important de fermer DB Browser avant qu'un autre programme y accède, car SQLite utilise un système de verrouillage de fichier. Si DB Browser garde le fichier ouvert, l'application Flutter ne pourra pas écrire dedans et plantera.





**Q2.1 :** Quel est le rôle de chacun des packages ?
**Réponse :** 
- `sqflite` : fournit l'API pour exécuter des requêtes SQLite en Flutter.
- `path` : sert à construire des chemins de fichiers corrects pour tous les systèmes d'exploitation (pour trouver le fichier .db).
- `sqflite_common_ffi` : Permet à `sqflite` de fonctionner sur Desktop (Windows/Linux/macOS) en utilisant FFI.

**Q2.3 :** Pourquoi id est-il de type int? (nullable) ? Pourquoi toMap() n'ajoute-t-il id que s'il n'est pas null ?
**Réponse :** `id` est nullable car avant d'être inséré dans la base, l'objet n'a pas encore d'identifiant (c'est SQLite qui le génère via AUTOINCREMENT). Dans `toMap()`, on n'ajoute l'`id` que s'il existe déjà, sinon on laisse SQLite générer la valeur par défaut.

**Question de réflexion (Q2.4) :** Pourquoi utilise-t-on ici un constructeur factory plutôt qu'un constructeur classique ? Pourquoi écrit-on (map['prix'] as num).toDouble() au lieu de map['prix'] as double?
**Réponse :** On utilise `factory` car `fromMap` ne crée pas forcément une nouvelle instance de manière classique (et permet d'appliquer de la logique de conversion). On utilise `(map['prix'] as num).toDouble()` car SQLite peut renvoyer un `int` (par exemple `5`) ou un `double` (par exemple `5.0`) pour une colonne REAL. Passer par `num` évite un crash de type.