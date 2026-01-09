import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const MessagesPage({
    super.key,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Flèche de retour
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: onBackPressed ?? () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    padding: const EdgeInsets.all(8),
                  ),
                  
                  // Texte "Discussions" au centre
                  Text(
                    'Discussions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  // Logo réduit à droite
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 70,
                      maxHeight: 50,
                    ),
                    child: Image.asset(
                      'assets/logo-2.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 30,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            // Première discussion
            _buildMessageCard(
              sellerName: 'Nom du vendeur',
              carName: 'Mercedes GLE 53',
              price: '95 000 000 Fcfa',
              date: '30 mars 2025',
            ),
            
            const SizedBox(height: 12),
            
            // Deuxième discussion
            _buildMessageCard(
              sellerName: 'Vendeur Auto',
              carName: 'Ford Mustang',
              price: '28 000 000 Fcfa',
              date: '25 mars 2025',
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget pour les cartes de discussion (CORRIGÉ - pas de débordement)
  Widget _buildMessageCard({
    required String sellerName,
    required String carName,
    required String price,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar/icône à gauche
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(12, 192, 223, 0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF0CC0DF),
                    size: 28,
                  ),
                ),
              ),
              
              const SizedBox(width: 12), // Réduit de 16 à 12
              
              // Contenu avec largeurs contrôlées
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Partie GAUCHE : Nom du vendeur et voiture
                    Flexible(
                      flex: 3, // 60% de l'espace
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sellerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            carName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 8), // Espacement entre les colonnes
                    
                    // Partie DROITE : Prix et date
                    Flexible(
                      flex: 2, // 40% de l'espace
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 16, // Réduit de 18 à 16
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0CC0DF),
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}