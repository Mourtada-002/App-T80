import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 16, // Augmenté pour plus d'espace
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0CC0DF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12), // Bordure arrondie en bas
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // Première ligne avec logo T80 et icône de compte
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo T80
                Image.asset(
                  'assets/logo 2.png',
                  width: 100,
                  height: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/icone.png',
                      width: 100,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(8),
                          child: const Text(
                            'T80',
                            style: TextStyle(
                              color: Color(0xFF0CC0DF),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                
                // Icône de compte
                GestureDetector(
                  onTap: () {
                    // Action pour le compte
                  },
                  child: Image.asset(
                    'assets/icone.png',
                    width: 80,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 28,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16), // Augmenté l'espace
          
          // Barre de recherche cliquable
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                // Action quand on clique sur la barre de recherche
                print('Barre de recherche cliquée');
                // Vous pouvez ajouter une navigation vers la page de recherche ici
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16), // Augmenté le padding
                    const Icon(
                      Icons.search,
                      color: Color(0xFF0CC0DF), // Bleu comme le fond
                      size: 22, // Légèrement plus grand
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Recherche...', // Simple texte au lieu de TextField
                        style: TextStyle(
                          color: Colors.grey[600], // Gris foncé pour le texte
                          fontSize: 16, // Plus grand pour meilleure lisibilité
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20), // Plus d'espace avant le texte
          
          // Texte "Acheter une Voiture, une moto avec T80"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 14, // Légèrement plus grand
                ),
                const SizedBox(width: 10),
                Text(
                  'Acheter une Voiture, une moto avec T80',
                  style: const TextStyle(
                    color: Colors.white, // Blanc pur
                    fontSize: 14, // Augmenté de 12 à 14
                    fontWeight: FontWeight.w500, // Légèrement plus gras
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}