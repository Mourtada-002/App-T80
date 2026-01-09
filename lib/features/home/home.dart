import 'package:flutter/material.dart';
import 'package:t80/features/account/account_page.dart';
import 'package:t80/features/favoris/favoris.dart';
import 'package:t80/features/home/widgets/header_section.dart';
import 'package:t80/features/home/widgets/body_section.dart';
import 'package:t80/features/home/widgets/footer_section.dart';
import 'package:t80/features/messages/messages_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Liste des pages principales
  List<Widget> get _pages => [
    // Page Accueil avec HeaderSection
    Column(
      children: [
        const HeaderSection(),
        Expanded(child: BodySection()),
      ],
    ),
    // Page Favoris avec flèche fonctionnelle
    FavoritesPage(
      onBackPressed: () {
        setState(() {
          _selectedIndex = 0; // Retour à l'accueil
        });
      },
    ),
    // Page Messages
    MessagesPage(
      onBackPressed: () {
        setState(() {
          _selectedIndex = 0;
        });
      },
    ),
    // Page Compte (maintenant accessible depuis HeaderSection)
    AccountPage(
      onBackPressed: () {
        setState(() {
          _selectedIndex = 0; // Retour à l'accueil
        });
      },
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: FooterSection(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}