import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final VoidCallback? onBackPressed;

  FavoritesPage({
    super.key,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Hauteur totale contrôlée
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0CC0DF),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flèche de retour - SANS fond blanc
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 30, // Agrandi
                    ),
                    onPressed: onBackPressed ?? () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    padding: const EdgeInsets.all(8),
                  ),
                  
                  // Logo image avec largeur contrôlée
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 150, // Largeur maximale contrôlée
                      maxHeight: 100, // Hauteur maximale contrôlée
                    ),
                    child: Image.asset(
                      'assets/logo-2.png', // Remplacez par votre image logo
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  // Espace vide pour équilibrer (même largeur que la flèche)
                  const SizedBox(
                    width: 48, // Même largeur que le IconButton
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section titre (NE PAS TOUCHER - déjà parfait)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vos véhicules favoris',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _favoriteCars.isEmpty 
                      ? 'Aucun véhicule' 
                      : '${_favoriteCars.length} véhicule${_favoriteCars.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Liste des favoris (seulement Mercedes GLE 53)
            ..._favoriteCars.map((car) => _buildFavoriteCarCard(
                  carName: car['name']!,
                  price: car['price']!,
                  imageUrl: car['image']!,
                )),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Liste avec SEULEMENT la Mercedes GLE 53
  final List<Map<String, String>> _favoriteCars = [
    {
      'name': 'Mercedes GLE 53',
      'price': '95.000.000 Fcfa',
      'image': 'assets/mercedes-GLE.png',
    },
  ];

  // Widget pour les cartes de voiture favorites (NE PAS TOUCHER)
  Widget _buildFavoriteCarCard({
    required String carName,
    required String price,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image sans espace en bas
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          height: 180,
                          child: const Center(
                            child: Icon(
                              Icons.car_rental,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Cœur favori (REMPLI)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Section texte - padding réduit et alignement ajusté
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Partie gauche : Nom et prix
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          carName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0CC0DF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Partie droite : Bouton Contact
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0CC0DF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Contacter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}