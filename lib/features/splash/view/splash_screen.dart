import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../home/view/home_screen.dart';
import '../viewmodel/splash_viewmodel.dart';
import '../../../shared/widgets/crescent_moon.dart';
import '../../../shared/widgets/star_field.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Entrance animations
  late final AnimationController _fadeCtrl;
  late final AnimationController _slideCtrl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;
  late final Animation<double> _arabicFade;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeIn = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _arabicFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _fadeCtrl.forward();
    _slideCtrl.forward();

    // Start the splash timer via ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().startSplash();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashViewModel>(
      builder: (context, vm, _) {
        // Navigate when splash is done
        if (vm.state == SplashState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, anim, __) => const HomeScreen(),
                  transitionsBuilder: (_, anim, __, child) => FadeTransition(
                    opacity: anim,
                    child: child,
                  ),
                  transitionDuration: const Duration(milliseconds: 700),
                ),
              );
            }
          });
        }

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background image (loaded from assets)
              _SplashBackground(),

              // Dark overlay for readability
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xCC0D2318),
                      Color(0xBB1C3A2E),
                      Color(0xEE0D2318),
                    ],
                  ),
                ),
              ),

              // Animated star field
              StarField(
                starCount: 40,
                starColor: AppColors.goldLight,
                maxRadius: 2.0,
              ),

              // Content
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),

                        // Crescent moon
                        const CrescentMoon(size: 72),

                        const SizedBox(height: 32),

                        // Main heading
                        Text(
                          AppStrings.homeGreeting,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldPale,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 6),

                        // Mubarak
                        Text(
                          AppStrings.homeMubarak,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: AppColors.goldPrimary,
                            letterSpacing: 4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        // Divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 0.8,
                              color: AppColors.goldPrimary.withOpacity(0.6),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.goldPrimary,
                                ),
                              ),
                            ),
                            Container(
                              width: 48,
                              height: 0.8,
                              color: AppColors.goldPrimary.withOpacity(0.6),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Arabic calligraphy
                        FadeTransition(
                          opacity: _arabicFade,
                          child: Text(
                            AppStrings.splashArabic,
                            style: GoogleFonts.scheherazadeNew(
                              fontSize: 38,
                              fontWeight: FontWeight.w600,
                              color: AppColors.goldLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Tagline
                        Text(
                          AppStrings.splashTagline,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: AppColors.textMuted,
                            letterSpacing: 2.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const Spacer(flex: 3),

                        // Loading indicator
                        SizedBox(
                          width: 32,
                          height: 2,
                          child: LinearProgressIndicator(
                            backgroundColor:
                                AppColors.goldPrimary.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.goldPrimary,
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Tries to load the Eid image from assets; falls back to a gradient.
class _SplashBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.4,
          colors: [
            Color(0xFF2D5E45),
            Color(0xFF1C3A2E),
            Color(0xFF0D2318),
          ],
        ),
      ),
      child: Image.asset(
        'assets/images/eid_splash.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}
