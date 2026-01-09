import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:t80/features/home/create_post_page.dart';
import 'package:t80/profile_manager.dart';
import 'package:t80/post_manager.dart';

class AccountPage extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const AccountPage({
    super.key,
    this.onBackPressed,
  });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with SingleTickerProviderStateMixin {
  bool _isSettingsExpanded = false;
  bool _isNotificationsExpanded = false;
  bool _notificationsEnabled = true;
  late AnimationController _settingsAnimationController;

  @override
  void initState() {
    super.initState();
    
    _settingsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _settingsAnimationController.dispose();
    super.dispose();
  }

  void _toggleSettings() {
    if (_isSettingsExpanded) {
      _closeSettings();
    } else {
      _openSettings();
    }
  }

  void _openSettings() {
    setState(() {
      _isSettingsExpanded = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _settingsAnimationController.forward();
    });
  }

  void _closeSettings() {
    _settingsAnimationController.reverse().then((_) {
      setState(() {
        _isSettingsExpanded = false;
        _isNotificationsExpanded = false;
      });
    });
  }

  void _editProfile() {
    final profileManager = Provider.of<ProfileManager>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => _EditProfileDialog(
        currentProfile: profileManager.userProfile,
        onSave: (newProfile) {
          profileManager.updateProfile(newProfile);
        },
      ),
    );
  }

  void _editPost(Post post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Édition du post: ${post.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileManager = Provider.of<ProfileManager>(context);
    final userProfile = profileManager.userProfile;
    final postManager = Provider.of<PostManager>(context);
    
    final userPosts = postManager.getPostsByUser(
      profileManager.userProfile.getOrCreateUserId(),
    );
    final postCount = userPosts.length;

    return GestureDetector(
      onTap: () {
        if (_isSettingsExpanded) {
          _closeSettings();
        }
      },
      child: Scaffold(
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
                      onPressed: widget.onBackPressed ?? () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      padding: const EdgeInsets.all(8),
                    ),
                    
                    const Text(
                      'Mon Compte',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: _toggleSettings,
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(userProfile),
                  
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mes postes',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          postCount == 0 
                            ? 'Aucun véhicule' 
                            : '$postCount véhicule${postCount > 1 ? 's' : ''}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (userPosts.isNotEmpty)
                    ...userPosts.map((post) => _buildPostCard(post)),
                  
                  if (userPosts.isEmpty)
                    _buildEmptyPostsSection(),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),

            if (_isSettingsExpanded)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeSettings,
                  child: AnimatedBuilder(
                    animation: _settingsAnimationController,
                    builder: (context, child) {
                      final animationValue = _settingsAnimationController.value;
                      
                      return Stack(
                        children: [
                          Container(
                            color: Color.fromRGBO(0, 0, 0, animationValue * 0.4),
                          ),
                          
                          Positioned(
                            right: -300 + (300 * animationValue),
                            top: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 300,
                                color: Colors.white,
                                child: _buildSettingsMenu(userProfile),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenu(UserProfile userProfile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _closeSettings,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 8),
              const Text(
                'Paramètres',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  text: userProfile.fullName,
                  onTap: _editProfile,
                ),
                
                Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.notifications_outlined,
                      text: 'Notification',
                      onTap: () {
                        setState(() {
                          _isNotificationsExpanded = !_isNotificationsExpanded;
                        });
                      },
                      hasArrow: true,
                      isExpanded: _isNotificationsExpanded,
                    ),
                    
                    if (_isNotificationsExpanded)
                      _buildSubMenuItem(
                        icon: Icons.notifications_active_outlined,
                        text: 'Activer/Désactiver',
                        isSwitch: true,
                        switchValue: _notificationsEnabled,
                        onSwitchChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                  ],
                ),
                
                _buildMenuItem(
                  icon: Icons.security_outlined,
                  text: 'Conditions et Politique de confidentialité',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ouverture des conditions de confidentialité'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            border: Border(
              top: BorderSide(
                color: Colors.grey[300]!,
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: Text(
              'T80 From RoifX 2026',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(UserProfile userProfile) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
              
              if (!mounted || pickedFile == null) return;
              
              final profileManager = Provider.of<ProfileManager>(context, listen: false);
              profileManager.updateProfileImage(File(pickedFile.path));
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF5F5F5),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
                image: userProfile.profileImage != null
                    ? DecorationImage(
                        image: FileImage(userProfile.profileImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: userProfile.profileImage == null
                  ? const Icon(
                      Icons.add_a_photo,
                      size: 30,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            userProfile.fullName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.phone,
                color: Color(0xFF0CC0DF),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                userProfile.phoneNumber,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Color(0xFF0CC0DF),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                userProfile.neighborhood,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          InkWell(
            onTap: _editProfile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0CC0DF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Modifier le profil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPostsSection() {
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
              Icons.car_rental,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun véhicule publié',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Commencez par créer votre première annonce !',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePostPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0CC0DF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Créer un post',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
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
            
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          post.formattedPrice,
                          style: const TextStyle(
                            fontSize: 18,
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
                  
                  InkWell(
                    onTap: () => _editPost(post),
                    child: Container(
                      margin: const EdgeInsets.only(left: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0CC0DF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Modifier',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
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
              post.imagePaths.isNotEmpty
                  ? PageView.builder(
                      controller: _pageController,
                      itemCount: post.imagePaths.length,
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
                          child: Image.file(
                            File(post.imagePaths[index]),
                            fit: BoxFit.cover,
                            height: 300,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildImagePlaceholder();
                            },
                          ),
                        );
                      },
                    )
                  : _buildImagePlaceholder(),
              
              // Indicateurs de page (les petits points)
              if (post.imagePaths.length > 1)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      post.imagePaths.length,
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

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[300],
      height: 300,
      child: const Center(
        child: Icon(
          Icons.car_rental,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool hasArrow = false,
    bool isExpanded = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF0CC0DF),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            if (hasArrow)
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubMenuItem({
    required IconData icon,
    required String text,
    bool isSwitch = false,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                ),
              ),
            ),
            if (isSwitch)
              Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeThumbColor: const Color(0xFF0CC0DF),
                activeTrackColor: const Color.fromRGBO(12, 192, 223, 0.5),
              ),
          ],
        ),
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  final UserProfile currentProfile;
  final Function(UserProfile) onSave;

  const _EditProfileDialog({
    required this.currentProfile,
    required this.onSave,
  });

  @override
  State<_EditProfileDialog> createState() => __EditProfileDialogState();
}

class __EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _neighborhoodController;
  File? _newImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentProfile.fullName);
    _phoneController = TextEditingController(text: widget.currentProfile.phoneNumber);
    _neighborhoodController = TextEditingController(text: widget.currentProfile.neighborhood);
    _newImage = widget.currentProfile.profileImage;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Modifier le profil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 20),
              
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF5F5F5),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 2,
                    ),
                    image: _newImage != null
                        ? DecorationImage(
                            image: FileImage(_newImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _newImage == null
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 30,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom & Prénom',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _neighborhoodController,
                decoration: InputDecoration(
                  labelText: 'Quartier',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final updatedProfile = UserProfile(
                          profileImage: _newImage,
                          fullName: _nameController.text,
                          phoneNumber: _phoneController.text,
                          neighborhood: _neighborhoodController.text,
                          userId: widget.currentProfile.userId,
                        );
                        widget.onSave(updatedProfile);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0CC0DF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Enregistrer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}