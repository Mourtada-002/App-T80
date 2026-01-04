import 'package:flutter/material.dart';

class BodySection extends StatelessWidget {
  const BodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre "Voiture de luxe à Bamako"
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Voiture de luxe\nà Bamako',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0CC0DF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Contact',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Section Contact avec icônes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildContactIcon(Icons.phone, color: Colors.green),
                  const SizedBox(width: 24),
                  _buildContactIcon(Icons.message, color: Colors.blue),
                  const SizedBox(width: 24),
                  _buildContactIcon(Icons.videocam, color: Colors.purple),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Séparateur
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: Colors.grey[300],
                thickness: 1,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Carte Ford Mustang
            _buildCarCard(
              carName: 'Ford Mustang',
              price: '28.000.000 Fcfa',
              imageUrl: 'assets/ford_mustang.jpg', // Remplacez par votre image
            ),
            
            const SizedBox(height: 16),
            
            // Carte Mercedes GLE 53
            _buildCarCard(
              carName: 'Mercedes GLE 53',
              price: '95.000.000 Fcfa',
              imageUrl: 'assets/mercedes.png', // Remplacez par votre image
            ),
            
            const SizedBox(height: 30),
            
            // Bouton "Question"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Action pour le bouton Question
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0CC0DF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Question',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Bouton "Nouveau"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Action pour le bouton Nouveau
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0CC0DF), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Nouveau',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0CC0DF),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40), // Espace pour la navigation bar
          ],
        ),
      ),
    );
  }

  // Widget pour les icônes de contact
  Widget _buildContactIcon(IconData icon, {required Color color}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        // ignore: deprecated_member_use
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }

  // Widget pour les cartes de voiture
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
            // Image de la voiture
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
            
            // Nom et prix de la voiture
            Padding(
              padding: const EdgeInsets.all(16),
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
          ],
        ),
      ),
    );
  }
}