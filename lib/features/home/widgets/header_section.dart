import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t80/profile_manager.dart';
import 'package:t80/features/account/account_page.dart';
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileManager = Provider.of<ProfileManager>(context);
    final userProfile = profileManager.userProfile;
    
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0CC0DF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLogo(),
                _buildProfileAvatar(context, userProfile.profileImage),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Barre de recherche cliquable
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                debugPrint('Barre de recherche cliquée');
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(
                      Icons.search,
                      color: Color(0xFF0CC0DF),
                      size: 22,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Recherche...',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Acheter une Voiture, une moto avec T80',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 100,
      height: 60,
      child: Image.asset(
        'assets/logo-2.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/icone.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'T80',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, File? imageFile) {
    return GestureDetector(
      onTap: () {
        // Naviguer vers AccountPage quand on clique sur l'avatar
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountPage(
              onBackPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: imageFile != null
              ? Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultProfileIcon();
                  },
                )
              : _buildDefaultProfileIcon(),
        ),
      ),
    );
  }

  Widget _buildDefaultProfileIcon() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: Icon(
          Icons.person_outline,
          color: Color(0xFF0CC0DF),
          size: 28,
        ),
      ),
    );
  }
}