import 'package:flutter/material.dart';

class BodySection extends StatelessWidget {
  const BodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION BLEUE avec titre, bouton contact et image voiture
            Container(
              margin: const EdgeInsets.only(
                top: 30,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: const Color(0xFF0CC0DF).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Partie gauche : Texte et bouton - AVEC PADDING
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Voiture de luxe\nà Bamako',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0CC0DF),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              'Contact',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Partie droite : Image de voiture
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 180,
                      child: Image.asset(
                        'assets/rolls-royce.png',
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.directions_car,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // NOUVELLE SECTION : 3 images + bouton "+" sur la même ligne
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Première image
                    _buildImageCard('assets/logo-3.png'),
                    
                    // Deuxième image
                    _buildImageCard('assets/image2.jpg'),
                    
                    // Troisième image
                    _buildImageCard('assets/image3.jpg'),
                    
                    // Bouton "+" bleu
                    _buildPlusButton(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Carte Ford Mustang
            _buildCarCard(
              carName: 'Ford Mustang',
              price: '28.000.000 Fcfa',
              imageUrl: 'assets/ford-mustang.png',
            ),
            
            const SizedBox(height: 16),
            
            // Carte Mercedes GLE 53
            _buildCarCard(
              carName: 'Mercedes GLE 53',
              price: '95.000.000 Fcfa',
              imageUrl: 'assets/mercedes-GLE.png',
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget pour les cartes d'images avec nouvelles dimensions
  Widget _buildImageCard(String imagePath) {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        color: const Color(0xFF0CC0DF),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF0CC0DF),
              child: const Center(
                child: Icon(
                  Icons.photo,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget pour le bouton "+" avec nouvelles dimensions
  Widget _buildPlusButton() {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        color: const Color(0xFF0CC0DF),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: const Color(0xFF0CC0DF).withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  // Widget pour les cartes de voiture MODIFIÉ
  Widget _buildCarCard({
    required String carName,
    required String price,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
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
            ),
            
            // Section avec nom, prix et coeur
            Padding(
              padding: const EdgeInsets.all(16),
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
                        const SizedBox(height: 8),
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
                  
                  // Partie droite : Coeur favoris
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Color(0xFF0CC0DF),
                        size: 28,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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