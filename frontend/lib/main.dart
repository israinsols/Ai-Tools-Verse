import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constants/app_theme.dart';
import 'models/tool.dart';
import 'models/category.dart';
import 'models/user.dart';
import 'models/review.dart';
import 'models/subscription.dart';
import 'models/payment_card.dart';
import 'models/app_notification.dart';
import 'screens/auth/splash_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/subscription_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  if (!kIsWeb) {
    try {
      final key = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
      debugPrint('Stripe key loaded: ${key.isNotEmpty ? "YES (${key.substring(0, 10)}...)" : "NO - EMPTY"}');
      Stripe.publishableKey = key;
      await Stripe.instance.applySettings();
      debugPrint('Stripe initialized successfully');
    } catch (e) {
      debugPrint('Stripe init ERROR: $e');
    }
  } else {
    debugPrint('Skipping Stripe init on Web');
  }

  await Hive.initFlutter();
  Hive.registerAdapter(ToolAdapter());
  Hive.registerAdapter(PricingTypeAdapter());
  Hive.registerAdapter(PricingPlanAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ReviewAdapter());
  Hive.registerAdapter(SubscriptionTierAdapter());
  Hive.registerAdapter(SubscriptionAdapter());
  Hive.registerAdapter(PaymentCardAdapter());
  Hive.registerAdapter(AppNotificationAdapter());
  await Hive.openBox('bookmarks');
  await Hive.openBox('recent_searches');
  await Hive.openBox('settings');
  await Hive.openBox('app');
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    ref.read(subscriptionProvider.notifier).checkTrialExpiry();
    
    return MaterialApp(
      title: 'AIVerse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
      home: const SplashScreen(),
    );
  }
}
