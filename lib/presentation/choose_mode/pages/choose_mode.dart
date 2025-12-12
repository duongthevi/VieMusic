import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart'; // Sử dụng GoRouter thay cho Navigator.push

import '../../../common/widgets/button/basic_app_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/theme_cubit.dart';

class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppImages.chooseModeBG),
              ),
            ),
          ),

          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                children: [
                  // Logo
                  Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(AppVectors.logo, width: 150,),
                  ),

                  const Spacer(),

                  const Text(
                    'Choose Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Choose your favorite background mode.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50),

                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, currentThemeMode) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ModeOption(
                            iconPath: AppVectors.moon,
                            title: 'Dark Mode',
                            mode: ThemeMode.dark,
                            isSelected: currentThemeMode == ThemeMode.dark,
                            onTap: () {
                              context.read<ThemeCubit>().updateTheme(ThemeMode.dark);
                            },
                          ),
                          const SizedBox(width: 40),
                          _ModeOption(
                            iconPath: AppVectors.sun,
                            title: 'Light Mode',
                            mode: ThemeMode.light,
                            isSelected: currentThemeMode == ThemeMode.light,
                            onTap: () {
                              context.read<ThemeCubit>().updateTheme(ThemeMode.light);
                            },
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 50),

                  // Nút Continue
                  BasicAppButton(
                    onPressed: () {
                      context.push('/signup-or-signin');
                    },
                    title: 'Continue',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  final String iconPath;
  final String title;
  final ThemeMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeOption({
    required this.iconPath,
    required this.title,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = isSelected ? Colors.white : AppColors.grey;
    final selectedIconBackground = isSelected ? const Color(0xff30393C) : const Color(0xff30393C).withOpacity(0.5);

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: selectedIconBackground,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selectedColor,
            fontSize: 17,
          ),
        )
      ],
    );
  }
}