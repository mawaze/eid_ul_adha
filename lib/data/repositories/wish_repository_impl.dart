import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/wish_model.dart';
import '../../domain/repositories/wish_repository.dart';

class WishRepositoryImpl implements WishRepository {
  final List<WishModel> _localHistory = [];

  @override
  String getDefaultMessage(String category) {
    return AppStrings.defaultMessages[category] ??
        AppStrings.defaultMessages['All']!;
  }

  @override
  Future<void> saveWish(WishModel wish) async {
    // In a production app this would persist to SharedPreferences / Hive.
    // Kept in-memory here to avoid adding extra dependencies.
    _localHistory.insert(0, wish);
  }

  @override
  Future<List<WishModel>> getWishHistory() async {
    return List.unmodifiable(_localHistory);
  }

  @override
  Future<void> shareWish(WishModel wish) async {
    final text =
        '${AppStrings.sharePrefix}${wish.message}${AppStrings.shareSuffix}';
    await Share.share(text, subject: 'Eid ul Adha Mubarak!');
  }
}
