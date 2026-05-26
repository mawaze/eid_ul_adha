import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_theme.dart';
import '../data/repositories/wish_repository_impl.dart';
import '../domain/repositories/wish_repository.dart';
import '../features/home/viewmodel/home_viewmodel.dart';
import '../features/splash/view/splash_screen.dart';
import '../features/splash/viewmodel/splash_viewmodel.dart';

class EidApp extends StatelessWidget {
  const EidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Singleton — repository lives for the whole app lifetime
        Provider<WishRepository>(
          create: (_) => WishRepositoryImpl(),
        ),

        // Splash ViewModel — scoped to the lifecycle of the route,
        // but registered here so it's available on first frame.
        ChangeNotifierProvider<SplashViewModel>(
          create: (_) => SplashViewModel(),
        ),

        // Home ViewModel depends on WishRepository
        ChangeNotifierProvider<HomeViewModel>(
          create: (ctx) => HomeViewModel(ctx.read<WishRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'Eid Wishes',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}
