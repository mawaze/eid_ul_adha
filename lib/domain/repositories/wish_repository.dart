import '../../data/models/wish_model.dart';

abstract class WishRepository {
  /// Returns a default message for the given recipient category
  String getDefaultMessage(String category);

  /// Saves a sent wish to local history
  Future<void> saveWish(WishModel wish);

  /// Returns the history of sent wishes
  Future<List<WishModel>> getWishHistory();

  /// Shares a wish via the platform share sheet
  Future<void> shareWish(WishModel wish);
}
