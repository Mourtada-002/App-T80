// features/home/widgets/body_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t80/features/home/create_post_page.dart';
import 'package:t80/post_manager.dart';

class BodySection extends StatelessWidget {
  const BodySection({super.key});

  @override
  Widget build(BuildContext context) {
    final postManager = Provider.of<PostManager>(context);
    final posts = postManager.allPosts;

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

            // SECTION : 3 images + bouton "+" pour créer un post
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
                      color: const Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildImageCard('assets/logo-3.png'),
                    _buildBlueBox(),
                    _buildBlueBox(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePostPage(),
                          ),
                        );
                      },
                      child: _buildPlusButton(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // LISTE DES POSTS DYNAMIQUES
            if (posts.isNotEmpty)
              ...posts.map((post) => _buildPostCard(post, context)),
            
            if (posts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.car_rental,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Aucun véhicule disponible',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Soyez le premier à publier une annonce !',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        color: const Color(0xFF0CC0DF),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
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

  Widget _buildBlueBox() {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        color: const Color(0xFF0CC0DF).withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildPlusButton() {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        color: const Color(0xFF0CC0DF),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(12, 192, 223, 0.3),
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

  // Widget pour les cartes de post AVEC CARROUSEL CORRIGÉ
  Widget _buildPostCard(Post post, BuildContext context) {
    final postManager = Provider.of<PostManager>(context, listen: false);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARROUSEL D'IMAGES
            _buildImageCarousel(post),
            
            // Infos du post
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre, prix et cœur (à sa place originale)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.formattedPrice,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0CC0DF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Cœur favoris (à sa place originale)
                      IconButton(
                        onPressed: () {
                          postManager.toggleFavorite(post.id);
                        },
                        icon: Icon(
                          post.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: post.isFavorite ? Colors.red : const Color(0xFF0CC0DF),
                          size: 28,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Description
                  Text(
                    post.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Infos supplémentaires
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: post.isNew 
                              ? const Color.fromRGBO(12, 192, 223, 0.1)
                              : const Color.fromRGBO(255, 193, 7, 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          post.condition,
                          style: TextStyle(
                            color: post.isNew 
                                ? const Color(0xFF0CC0DF)
                                : Colors.amber[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      
                      const SizedBox(width: 4),
                      
                      Text(
                        post.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Catégories
                  Wrap(
                    spacing: 8,
                    children: post.categories.map((category) {
                      return Chip(
                        label: Text(
                          category,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.grey[100],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Nouvelle méthode pour le carrousel
  Widget _buildImageCarousel(Post post) {
    return StatefulBuilder(
      builder: (context, setState) {
        final PageController _pageController = PageController();
        int _currentPage = 0;
        
        return SizedBox(
          height: 300,
          width: double.infinity,
          child: Stack(
            children: [
              // PageView pour le carrousel
              post.images.isNotEmpty
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: post.images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: _buildPostImage(post.images[index]),
                        );
                      },
                    )
                  : _buildImagePlaceholder(),
              
              // Indicateurs de page (les petits points)
              if (post.images.length > 1)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      post.images.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostImage(String imagePath) {
    try {
      if (imagePath.startsWith('/')) {
        return Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          width: double.infinity,
          height: 300,
          errorBuilder: (context, error, stackTrace) {
            return _buildImagePlaceholder();
          },
        );
      } else {
        return Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 300,
          errorBuilder: (context, error, stackTrace) {
            return _buildImagePlaceholder();
          },
        );
      }
    } catch (e) {
      return _buildImagePlaceholder();
    }
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[300],
      height: 300,
      child: const Center(
        child: Icon(
          Icons.car_rental,
          size: 60,
          color: Colors.grey,
        ),
      ),
    );
  }
}