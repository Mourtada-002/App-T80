// lib/profile_manager.dart
import 'dart:io';
import 'package:flutter/material.dart';

class UserProfile {
  File? profileImage;
  String fullName;
  String phoneNumber;
  String neighborhood;
  String? userId;

  UserProfile({
    this.profileImage,
    this.fullName = "Nom & Prénom",
    this.phoneNumber = "Numéro de téléphone",
    this.neighborhood = "Quartier",
    this.userId,
  });

  UserProfile copyWith({
    File? profileImage,
    String? fullName,
    String? phoneNumber,
    String? neighborhood,
    String? userId,
  }) {
    return UserProfile(
      profileImage: profileImage ?? this.profileImage,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      neighborhood: neighborhood ?? this.neighborhood,
      userId: userId ?? this.userId,
    );
  }

  String getOrCreateUserId() {
    if (userId == null || userId!.isEmpty) {
      userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    }
    return userId!;
  }
}

class ProfileManager extends ChangeNotifier {
  static final ProfileManager _instance = ProfileManager._internal();
  factory ProfileManager() => _instance;
  ProfileManager._internal();

  UserProfile _userProfile = UserProfile();

  UserProfile get userProfile => _userProfile;

  void updateProfile(UserProfile newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }

  void updateProfileImage(File? imageFile) {
    _userProfile = _userProfile.copyWith(profileImage: imageFile);
    notifyListeners();
  }

  void updateProfileInfo({
    String? fullName,
    String? phoneNumber,
    String? neighborhood,
  }) {
    _userProfile = _userProfile.copyWith(
      fullName: fullName,
      phoneNumber: phoneNumber,
      neighborhood: neighborhood,
    );
    notifyListeners();
  }
}