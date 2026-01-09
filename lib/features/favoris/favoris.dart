// features/favoris/favoris.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t80/post_manager.dart';

class FavoritesPage extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const FavoritesPage({
    super.key,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final postManager = Provider.of<PostManager>(context);
    final favoritePosts = postManager.getFavoritePosts();
    final favoriteCount = favoritePosts.length;

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 150,
                      maxHeight: 100,
                    ),
                    child: Image.asset(
                      'assets/logo-2.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'Favoris',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 48),
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
                    favoriteCount == 0 
                      ? 'Aucun véhicule' 
                      : '$favoriteCount véhicule${favoriteCount > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            if (favoritePosts.isNotEmpty)
              ...favoritePosts.map((post) => _buildFavoritePostCard(post, context)),
            
            if (favoritePosts.isEmpty)
              _buildEmptyFavoritesSection(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFavoritesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
              Icons.favorite_border,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun véhicule favori',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Ajoutez des véhicules à vos favoris en cliquant sur le cœur !',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritePostCard(Post post, BuildContext context) {
    Provider.of<PostManager>(context, listen: false);
    
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
            _buildImageCarousel(post, context),
            
            // Section texte
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
                          post.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          post.formattedPrice,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0CC0DF),
                          ),
                        ),
                        const SizedBox(height: 8),
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
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              post.location,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
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

  // Méthode pour le carrousel d'images
  Widget _buildImageCarousel(Post post, BuildContext context) {
    final postManager = Provider.of<PostManager>(context, listen: false);
    
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
              
              // Indicateurs de page
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
              
              // Cœur favori
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    postManager.toggleFavorite(post.id);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 24,
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