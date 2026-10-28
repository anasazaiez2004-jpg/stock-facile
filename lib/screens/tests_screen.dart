import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/categorie_dao.dart';
import '../database/produit_dao.dart';
import '../models/categorie.dart';
import '../models/produit.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banc d\'essai')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Q3.3
          ElevatedButton(
            onPressed: () async {
              final db = await DatabaseHelper().database;
              final resultat = await db.rawQuery('SELECT COUNT(*) AS nb FROM categories');
              debugPrint('Nombre de catégories : ${resultat.first['nb']}');
            },
            child: const Text('Ouvrir la base'),
          ),

          // Q4.3 & Q4.4 : Ajouter une catégorie
          ElevatedButton(
            onPressed: () async {
              try {
                final nouvelle = Categorie(nom: 'Électroménager', description: 'Petits appareils');
                final id = await CategorieDao().insererCategorie(nouvelle);
                debugPrint('Catégorie insérée avec l\'id $id');
              } on DatabaseException catch (e) {
                if (e.isUniqueConstraintError()) {
                  debugPrint('Erreur : Cette catégorie existe déjà');
                } else {
                  debugPrint('Erreur SQLite : $e');
                }
              }
            },
            child: const Text('Test : ajouter une catégorie'),
          ),

          // Q4.8 : Ajouter un produit
          ElevatedButton(
            onPressed: () async {
              final produit = Produit(
                nom: 'Stylo bleu',
                prix: 0.500,
                quantite: 100,
                disponible: true,
                dateAjout: DateTime.now(),
                categorieId: 4,
              );
              final id = await ProduitDao().insererProduit(produit);
              debugPrint('Produit inséré avec l\'id $id');
            },
            child: const Text('Test : ajouter un produit'),
          ),

          // Q4.10 : Tester clé étrangère
          ElevatedButton(
            onPressed: () async {
              final produit = Produit(
                nom: 'Produit fantôme',
                prix: 1.0,
                quantite: 1,
                disponible: true,
                dateAjout: DateTime.now(),
                categorieId: 99, // Catégorie qui n'existe pas
              );
              try {
                await ProduitDao().insererProduit(produit);
              } catch (e) {
                debugPrint('Erreur clé étrangère : $e');
              }
            },
            child: const Text('Test : catégorie 99 (erreur)'),
          ),

          // Q4.11 : Tester prix négatif
          ElevatedButton(
            onPressed: () async {
              final produit = Produit(
                nom: 'Prix négatif',
                prix: -2.0,
                quantite: 1,
                disponible: true,
                dateAjout: DateTime.now(),
                categorieId: 1,
              );
              try {
                await ProduitDao().insererProduit(produit);
              } catch (e) {
                debugPrint('Erreur prix négatif : $e');
              }
            },
            child: const Text('Test : prix négatif (erreur)'),
          ),
        ],
      ),
    );
  }
}