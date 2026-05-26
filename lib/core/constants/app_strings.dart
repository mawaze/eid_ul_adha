abstract class AppStrings {
  // App
  static const String appName = 'Eid Wishes';

  // Splash
  static const String splashTagline = 'Share the Blessings';
  static const String splashArabic = 'عيد مبارك';

  // Home
  static const String homeGreeting = 'Eid ul Adha';
  static const String homeMubarak = 'Mubarak ';
  static const String homeSubtitle = 'Send warm wishes to your loved ones';
  static const String homeSendButton = 'Send Eid Wishes';
  static const String homeCardStyle = 'Card Style';
  static const String homeMessage = 'Your Message';
  static const String homeRecipient = 'Send To';

  // Recipient categories
  static const List<String> recipientCategories = [
    'Family',
    'Love',
    'Colleagues',
    'All',
  ];

  // Card styles
  static const List<String> cardStyles = [
    'Classic',
    'Luxe',
    'Night',
    'Ivory',
  ];

  // Default messages
  static const Map<String, String> defaultMessages = {
    'Family': 'Wishing our beloved family a blessed Eid ul Adha filled with joy, peace, and Allah\'s infinite blessings. May our bond grow stronger with each passing day. Eid Mubarak! 🌙',
    'Love': 'To my Love, may this Eid ul Adha bring you and your family immense happiness and divine blessings. Wishing you a joyful and memorable celebration! Eid Mubarak! ✨',
    'Colleagues': 'Warmest Eid ul Adha greetings to you and your family. May this blessed occasion fill your life with happiness, success, and prosperity. Eid Mubarak! 🕌',
    'All': 'May the blessings of Eid ul Adha fill your heart with gratitude and your home with love. Wishing you a beautiful and blessed celebration. Eid Mubarak! 🌟',
  };

  // Share text template
  static const String sharePrefix = '🌙 Eid ul Adha Mubarak!\n\n';
  static const String shareSuffix = '\n\nSent with ❤️ via Eid Wishes App';

  // Bottom nav
  static const List<String> navLabels = ['Home', 'Cards', 'Contacts', 'History'];

  // Max chars
  static const int maxMessageLength = 300;
}
