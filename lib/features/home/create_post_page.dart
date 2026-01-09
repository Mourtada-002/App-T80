// features/home/create_post_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:t80/profile_manager.dart';
import 'package:t80/post_manager.dart';

class CreatePostPage extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const CreatePostPage({
    super.key,
    this.onBackPressed,
  });

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final List<File> _images = [];
  bool _isNew = true;
  final List<String> _selectedCategories = [];

  // Catégories disponibles
  final List<String> _categories = [
    'SUV',
    'Berline',
    'Coupé',
    'Sport',
    'Luxe',
    '4x4',
    'Utilitaire',
    'Électrique',
    'Hybride',
  ];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  void _submitPost() {
    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      final profileManager = Provider.of<ProfileManager>(context, listen: false);
      final postManager = Provider.of<PostManager>(context, listen: false);
      
      // Créer un titre automatique à partir de la marque et du modèle
      final title = '${_brandController.text} ${_modelController.text}';
      
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: profileManager.userProfile.userId ?? '',
        title: title,
        description: _descriptionController.text,
        price: double.parse(_priceController.text.replaceAll(',', '.')),
        imagePaths: _images.map((file) => file.path).toList(),
        isNew: _isNew,
        brand: _brandController.text,
        model: _modelController.text,
        year: int.parse(_yearController.text),
        location: _locationController.text,
        categories: _selectedCategories,
      );
      
      postManager.addPost(newPost);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Annonce publiée avec succès !'),
          duration: Duration(seconds: 2),
        ),
      );
      
      Navigator.pop(context);
    } else if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez ajouter au moins une image'),
        ),
      );
    }
  }

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
                    'Créer un post',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section images
              _buildImagesSection(),
              
              const SizedBox(height: 24),
              
              // Informations du véhicule (sans titre séparé)
              _buildVehicleInfoSection(),
              
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description*',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Prix
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Prix (Fcfa)*',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return 'Prix invalide';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // État du véhicule
              _buildConditionSection(),
              
              const SizedBox(height: 24),
              
              // Catégories
              _buildCategoriesSection(),
              
              const SizedBox(height: 32),
              
              // Bouton publier
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0CC0DF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Publier l\'annonce',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos du véhicule*',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        
        if (_images.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(_images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        
        const SizedBox(height: 12),
        
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF0CC0DF),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate,
                  size: 40,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ajouter des photos',
                  style: TextStyle(
                    color: Color(0xFF0CC0DF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'État du véhicule',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text('Neuf'),
                selected: _isNew,
                onSelected: (selected) {
                  setState(() {
                    _isNew = true;
                  });
                },
                selectedColor: const Color(0xFF0CC0DF),
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: _isNew ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ChoiceChip(
                label: const Text('Occasion'),
                selected: !_isNew,
                onSelected: (selected) {
                  setState(() {
                    _isNew = false;
                  });
                },
                selectedColor: const Color(0xFF0CC0DF),
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: !_isNew ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations du véhicule',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: 'Marque*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la marque';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _modelController,
                decoration: InputDecoration(
                  labelText: 'Modèle*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le modèle';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Année*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'année';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Année invalide';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Localisation*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la localisation';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catégories',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) => _toggleCategory(category),
              selectedColor: const Color(0xFF0CC0DF),
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}