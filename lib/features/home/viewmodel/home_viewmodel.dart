import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/wish_model.dart';
import '../../../domain/repositories/wish_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final WishRepository _repository;

  HomeViewModel(this._repository) {
    _messageController.text = _repository.getDefaultMessage(_selectedCategory);
    _messageController.addListener(_onMessageChanged);
  }

  // ── State ──────────────────────────────────────────────────────────────────

  String _selectedCategory = AppStrings.recipientCategories.first;
  String _selectedCardStyle = AppStrings.cardStyles.first;
  bool _isSending = false;
  bool _isSharing = false;
  String? _errorMessage;
  String? _successMessage;
  int _currentNavIndex = 0;

  final TextEditingController _messageController = TextEditingController();

  // ── Getters ────────────────────────────────────────────────────────────────

  String get selectedCategory => _selectedCategory;
  String get selectedCardStyle => _selectedCardStyle;
  bool get isSending => _isSending;
  bool get isSharing => _isSharing;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  int get currentNavIndex => _currentNavIndex;
  TextEditingController get messageController => _messageController;
  int get charCount => _messageController.text.length;

  // ── Actions ────────────────────────────────────────────────────────────────

  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _messageController.text = _repository.getDefaultMessage(category);
    _clearFeedback();
    notifyListeners();
  }

  void selectCardStyle(String style) {
    if (_selectedCardStyle == style) return;
    _selectedCardStyle = style;
    notifyListeners();
  }

  void setNavIndex(int index) {
    if (_currentNavIndex == index) return;
    _currentNavIndex = index;
    notifyListeners();
  }

  Future<void> sendWish() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      _errorMessage = 'Please write a message before sending.';
      notifyListeners();
      return;
    }

    _isSending = true;
    _clearFeedback();
    notifyListeners();

    try {
      final wish = WishModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        recipientCategory: _selectedCategory,
        message: message,
        cardStyle: _selectedCardStyle,
        sentAt: DateTime.now(),
      );

      await _repository.shareWish(wish);
      await _repository.saveWish(wish);

      _successMessage = 'Wish sent! Eid Mubarak 🌙';
    } catch (_) {
      _errorMessage = 'Could not send wish. Please try again.';
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void clearFeedbackManually() => _clearFeedback();

  // ── Private ────────────────────────────────────────────────────────────────

  void _onMessageChanged() => notifyListeners();

  void _clearFeedback() {
    _errorMessage = null;
    _successMessage = null;
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    super.dispose();
  }
}
