import 'package:file_loader/data/models/user_model.dart';
import 'package:file_loader/core/constants/app_constants.dart';
import 'package:file_loader/shared/extensions/string_extensions.dart';

class UserFilter {
  final String? country;
  final String? sex;
  final int? minFollowers;

  UserFilter({
    this.country,
    this.sex,
    this.minFollowers,
  });

  UserFilter copyWith({
    String? country,
    String? sex,
    int? minFollowers,
  }) {
    return UserFilter(
      country: country ?? this.country,
      sex: sex ?? this.sex,
      minFollowers: minFollowers ?? this.minFollowers,
    );
  }

  bool matches(UserModel user) {
    // Country filter
    if (country != null && country!.trimAndLower.isNotNullOrEmpty) {
      final userCountry = user.countryTitle?.trimAndLower ?? '';
      if (!userCountry.contains(country!.trimAndLower)) {
        return false;
      }
    }

    // Sex filter
    if (sex != null && 
        sex != AppConstants.sexAll && 
        sex!.trimAndLower.isNotNullOrEmpty) {
      final userSex = user.sex?.trimAndLower ?? '';
      if (userSex != sex!.trimAndLower) {
        return false;
      }
    }

    // Min followers filter
    if (minFollowers != null && minFollowers! > 0) {
      if (user.followersCount < minFollowers!) {
        return false;
      }
    }

    return true;
  }

  List<UserModel> apply(List<UserModel> users) {
    return users.where((user) => matches(user)).toList();
  }

  bool get hasActiveFilters {
    return (country != null && country!.trimAndLower.isNotNullOrEmpty) ||
        (sex != null && sex != AppConstants.sexAll) ||
        (minFollowers != null && minFollowers! > 0);
  }

  UserFilter clear() {
    return UserFilter();
  }
}

