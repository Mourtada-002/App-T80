// lib/post_manager.dart
import 'package:flutter/material.dart';

class Post {
  String id;
  String userId;
  String title;
  String description;
  double price;
  List<String> imagePaths;
  bool isNew;
  String brand;
  String model;
  int year;
  String location;
  DateTime createdAt;
  List<String> categories;
  bool isFavorite; // ← NOUVEAU: Propriété pour les favoris

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.imagePaths,
    required this.isNew,
    required this.brand,
    required this.model,
    required this.year,
    required this.location,
    required this.categories,
    DateTime? createdAt,
    this.isFavorite = false, // ← Par défaut non favori
  }) : createdAt = createdAt ?? DateTime.now();

  String get formattedPrice {
    return '${price.toStringAsFixed(3).replaceAll('.', ',')} Fcfa';
  }

  String get condition {
    return isNew ? 'Neuf' : 'Occasion';
  }

  String get fullInfo {
    return '$brand $model • $year • $location';
  }

  List<String> get images => imagePaths;
}

class PostManager extends ChangeNotifier {
  static final PostManager _instance = PostManager._internal();
  factory PostManager() => _instance;
  PostManager._internal();

  final List<Post> _posts = [];

  List<Post> get allPosts => List.from(_posts);

  List<Post> getPostsByUser(String userId) {
    return _posts.where((post) => post.userId == userId).toList();
  }

  List<Post> getFavoritePosts() {
    return _posts.where((post) => post.isFavorite).toList();
  }

  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  void removePost(String postId) {
    _posts.removeWhere((post) => post.id == postId);
    notifyListeners();
  }

  void updatePost(String postId, Post updatedPost) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = updatedPost;
      notifyListeners();
    }
  }

  Post? getPostById(String postId) {
    try {
      return _posts.firstWhere((post) => post.id == postId);
    } catch (e) {
      return null;
    }
  }

  // NOUVELLE MÉTHODE: Toggle favorite status
  void toggleFavorite(String postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(
        isFavorite: !_posts[index].isFavorite,
      );
      notifyListeners();
    }
  }

  // NOUVELLE MÉTHODE: Set favorite status
  void setFavorite(String postId, bool isFavorite) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(isFavorite: isFavorite);
      notifyListeners();
    }
  }
}

// NOUVELLE CLASSE: Extension pour copier avec modifications
extension PostCopyWith on Post {
  Post copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    double? price,
    List<String>? imagePaths,
    bool? isNew,
    String? brand,
    String? model,
    int? year,
    String? location,
    List<String>? categories,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePaths: imagePaths ?? this.imagePaths,
      isNew: isNew ?? this.isNew,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      location: location ?? this.location,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}