import 'package:file_loader/core/constants/app_constants.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String id;
  final String? lastSeen;
  final String? sex;
  final int followersCount;
  final String? countryId;
  final String? countryTitle;
  final String? cityId;
  final String? cityTitle;
  final String? bdate;
  final String? byear;
  final String? contacts;
  final String? connections;
  final String? canWritePrivateMessage;
  final String? canPost;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.id,
    this.lastSeen,
    this.sex,
    this.followersCount = 0,
    this.countryId,
    this.countryTitle,
    this.cityId,
    this.cityTitle,
    this.bdate,
    this.byear,
    this.contacts,
    this.connections,
    this.canWritePrivateMessage,
    this.canPost,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory UserModel.fromMap(Map<String, String> map) {
    return UserModel(
      firstName: map[AppConstants.firstName] ?? '',
      lastName: map[AppConstants.lastName] ?? '',
      id: map[AppConstants.id] ?? '',
      lastSeen: map[AppConstants.lastSeen],
      sex: map[AppConstants.sex],
      followersCount: int.tryParse(map[AppConstants.followersCount] ?? '0') ?? 0,
      countryId: map[AppConstants.countryId],
      countryTitle: map[AppConstants.countryTitle],
      cityId: map[AppConstants.cityId],
      cityTitle: map[AppConstants.cityTitle],
      bdate: map[AppConstants.bdate],
      byear: map[AppConstants.byear],
      contacts: map[AppConstants.contacts],
      connections: map[AppConstants.connections],
      canWritePrivateMessage: map[AppConstants.canWritePrivateMessage],
      canPost: map[AppConstants.canPost],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppConstants.firstName: firstName,
      AppConstants.lastName: lastName,
      AppConstants.id: id,
      AppConstants.lastSeen: lastSeen,
      AppConstants.sex: sex,
      AppConstants.followersCount: followersCount.toString(),
      AppConstants.countryId: countryId,
      AppConstants.countryTitle: countryTitle,
      AppConstants.cityId: cityId,
      AppConstants.cityTitle: cityTitle,
      AppConstants.bdate: bdate,
      AppConstants.byear: byear,
      AppConstants.contacts: contacts,
      AppConstants.connections: connections,
      AppConstants.canWritePrivateMessage: canWritePrivateMessage,
      AppConstants.canPost: canPost,
    };
  }
}

