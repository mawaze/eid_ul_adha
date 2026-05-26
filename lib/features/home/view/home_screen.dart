import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../home/view/widgets/card_style_thumb.dart';
import '../../home/view/widgets/hero_wish_card.dart';
import '../../home/view/widgets/recipient_chip.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return const _HomeScaffold();
  }
}

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: _HomeAppBar(),
      body: _HomeBody(),
        bottomNavigationBar: _BottomNav(),
    );
  }
}

// ── App Bar ─────────────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1C3A2E),
            Color(0xFF2D5E45),
            Color(0xFF1C3A2E),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x441C3A2E),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 72,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Crescent icon badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.goldPrimary.withOpacity(0.15),
                    border: Border.all(
                      color: AppColors.goldPrimary.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '☪',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.goldLight,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Title + subtitle
                Expanded(
                  child: Column(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.appName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.goldPale,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        'From M.Mawaze',
                        style: GoogleFonts.scheherazadeNew(
                          fontSize: 13,
                          color: AppColors.goldLight.withOpacity(0.85),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Share button
                GestureDetector(
                  onTap: () => context.read<HomeViewModel>().sendWish(),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFC8970A), Color(0xFFE8B84B)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldPrimary.withOpacity(0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.ios_share_rounded,
                      color: Color(0xFF1C3A2E),
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Body ────────────────────────────────────────────────────────────────────

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.md,
                AppDimensions.md,
                AppDimensions.md,
                AppDimensions.xl + 80, // extra for FAB
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero wish card
                  HeroWishCard(cardStyle: vm.selectedCardStyle),
                  const SizedBox(height: 24),

                  // Recipient section
                  _SectionLabel(AppStrings.homeRecipient),
                  const SizedBox(height: 10),
                  _RecipientRow(vm: vm),
                  const SizedBox(height: 24),

                  // Message section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionLabel(AppStrings.homeMessage),
                      Text(
                        '${vm.charCount}/${AppStrings.maxMessageLength}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: vm.charCount > AppStrings.maxMessageLength
                              ? AppColors.error
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _MessageInput(vm: vm),
                  const SizedBox(height: 24),

                  // Card style section
                  _SectionLabel(AppStrings.homeCardStyle),
                  const SizedBox(height: 10),
                  _CardStyleRow(vm: vm),
                  const SizedBox(height: 28),

                  // Send button
                  _SendButton(vm: vm),
                ],
              ),
            ),

            // Feedback overlay
            if (vm.errorMessage != null || vm.successMessage != null)
              _FeedbackBanner(
                message: vm.errorMessage ?? vm.successMessage!,
                isError: vm.errorMessage != null,
                onDismiss: vm.clearFeedbackManually,
              ),
          ],
        );
      },
    );
  }
}

// ── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }
}

// ── Recipient Row ────────────────────────────────────────────────────────────

class _RecipientRow extends StatelessWidget {
  final HomeViewModel vm;
  const _RecipientRow({required this.vm});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AppStrings.recipientCategories.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: RecipientChip(
              label: cat,
              isSelected: vm.selectedCategory == cat,
              onTap: () => context.read<HomeViewModel>().selectCategory(cat),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Message Input ────────────────────────────────────────────────────────────

class _MessageInput extends StatelessWidget {
  final HomeViewModel vm;
  const _MessageInput({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.emeraldSurface),
      ),
      child: TextField(
        controller: vm.messageController,
        maxLines: 5,
        maxLength: AppStrings.maxMessageLength,
        style: GoogleFonts.poppins(
          fontSize: 13.5,
          color: AppColors.textPrimary,
          height: 1.6,
        ),
        decoration: const InputDecoration(
          hintText: 'Write your Eid wishes...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(AppDimensions.md),
          counterText: '',
        ),
      ),
    );
  }
}

// ── Card Style Row ───────────────────────────────────────────────────────────

class _CardStyleRow extends StatelessWidget {
  final HomeViewModel vm;
  const _CardStyleRow({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: AppStrings.cardStyles.map((style) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CardStyleThumb(
            styleName: style,
            isSelected: vm.selectedCardStyle == style,
            onTap: () =>
                context.read<HomeViewModel>().selectCardStyle(style),
          ),
        );
      }).toList(),
    );
  }
}

// ── Send Button ──────────────────────────────────────────────────────────────

class _SendButton extends StatelessWidget {
  final HomeViewModel vm;
  const _SendButton({required this.vm});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: AppDimensions.durationMid),
      height: AppDimensions.buttonHeight,
      decoration: BoxDecoration(
        color: AppColors.emeraldDeep,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.emeraldDeep.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          onTap: vm.isSending
              ? null
              : () => context.read<HomeViewModel>().sendWish(),
          child: Center(
            child: vm.isSending
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.goldPrimary),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.homeSendButton,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.goldPale,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.send_rounded,
                        color: AppColors.goldPrimary,
                        size: 18,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Feedback Banner ──────────────────────────────────────────────────────────

class _FeedbackBanner extends StatelessWidget {
  final String message;
  final bool isError;
  final VoidCallback onDismiss;

  const _FeedbackBanner({
    required this.message,
    required this.isError,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: FadeScaleTransition(
        animation: const AlwaysStoppedAnimation(1.0),
        child: GestureDetector(
          onTap: onDismiss,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md, vertical: 14),
            decoration: BoxDecoration(
              color: isError
                  ? AppColors.error
                  : AppColors.emeraldDeep,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: isError ? Colors.white : AppColors.goldLight,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Bottom Nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          child: Center(
            child: GestureDetector(
              onTap: () => context.read<HomeViewModel>().setNavIndex(0),
              child: Container(
                width: 140,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1C3A2E),
                      Color(0xFF2D5E45),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1C3A2E).withOpacity(0.45),
                      blurRadius: 18,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: AppColors.goldPrimary.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: -2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.goldPrimary.withOpacity(0.35),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.goldPrimary.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.home_rounded,
                        color: AppColors.goldLight,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Home',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.goldPale,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
