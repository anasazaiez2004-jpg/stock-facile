-- Q1.5.1 : Tous les produits
SELECT * FROM produits;

1	Huile d'olive 1 L	18.5	24	1	2026-10-01T09:00:00	1
2	Couscous moyen 1 kg	2.3	40	1	2026-10-01T09:05:00	1
3	Eau minérale 1,5 L	0.85	120	1	2026-10-02T10:00:00	2
4	Jus d'orange 1 L	3.2	0	0	2026-10-02T10:10:00	2
5	Savon de Marseille	2.9	15	1	2026-10-03T11:00:00	3
6	Cahier 96 pages	1.6	60	1	2026-10-04T08:30:00	4


-- Q1.5.2 : Produits en rupture
SELECT * FROM produits WHERE quantite = 0;

4	Jus d'orange 1 L	3.2	0	0	2026-10-02T10:10:00	2



-- Q1.5.3 : Triés par prix
SELECT * FROM produits ORDER BY prix DESC;
1	Huile d'olive 1 L	18.5	24	1	2026-10-01T09:00:00	1
4	Jus d'orange 1 L	3.2	0	0	2026-10-02T10:10:00	2
5	Savon de Marseille	2.9	15	1	2026-10-03T11:00:00	3
2	Couscous moyen 1 kg	2.3	40	1	2026-10-01T09:05:00	1
6	Cahier 96 pages	1.6	60	1	2026-10-04T08:30:00	4
3	Eau minérale 1,5 L	0.85	120	1	2026-10-02T10:00:00	2



-- Q1.5.4 : Nom du produit et catégorie (INNER JOIN)
SELECT p.nom, c.nom AS categorie 
FROM produits p 
INNER JOIN categories c ON p.categorie_id = c.id;

Huile d'olive 1 L	Alimentation
Couscous moyen 1 kg	Alimentation
Eau minérale 1,5 L	Boissons
Jus d'orange 1 L	Boissons
Savon de Marseille	Hygiène
Cahier 96 pages	Papeterie


-- Q1.5.5 : Nombre de produits par catégorie
SELECT c.nom, COUNT(p.id) AS nombre 
FROM categories c 
LEFT JOIN produits p ON c.id = p.categorie_id 
GROUP BY c.nom;
Alimentation	2
Boissons	2
Hygiène	1
Papeterie	1


-- Q1.5.6 : Valeur totale du stock
SELECT SUM(prix * quantite) AS valeur_totale FROM produits;

777.5