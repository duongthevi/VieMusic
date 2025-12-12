import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/song/song_entity.dart';
import '../../bloc/favorite_button/favorite_button_cubit.dart';
import '../../bloc/favorite_button/favorite_button_state.dart';

class FavoriteButton extends StatelessWidget {
  final SongEntity songEntity;
  final Function? function;
  final double size;
  final bool isNeumorphic;

  const FavoriteButton({
    required this.songEntity,
    this.function,
    this.size = 25.0,
    this.isNeumorphic = false,
    super.key,
  });

  Widget _buildIcon(bool isFavorite, Color color, {bool isNeumorphic = false}) {
    if (isNeumorphic) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              offset: const Offset(-3, -3),
              blurRadius: 7,
            ),
            BoxShadow(
              color: Colors.grey.shade300.withOpacity(0.5),
              offset: const Offset(3, 3),
              blurRadius: 7,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
            size: size * 0.7,
            color: isFavorite ? Colors.redAccent : Colors.black45,
          ),
        ),
      );
    } else {
      return Icon(
        isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
        size: size,
        color: isFavorite ? Colors.redAccent : color,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color defaultIconColor = AppColors.darkGrey;

    return BlocProvider(
      create: (context) => FavoriteButtonCubit(),
      child: BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
        builder: (context, state) {
          bool currentFavoriteStatus = songEntity.isFavorite;

          if (state is FavoriteButtonUpdated) {
            currentFavoriteStatus = state.isFavorite;
          }

          if (state is FavoriteButtonInitial || state is FavoriteButtonUpdated) {
            final cubit = context.read<FavoriteButtonCubit>();

            Widget buttonContent = _buildIcon(
              currentFavoriteStatus,
              defaultIconColor,
              isNeumorphic: isNeumorphic,
            );

            final VoidCallback onPressedHandler = () async {
              await cubit.favoriteButtonUpdated(songEntity.id);
              if (function != null) {
                function!();
              }
            };

            if (isNeumorphic) {
              return GestureDetector(
                onTap: onPressedHandler,
                child: buttonContent,
              );
            } else {
              return IconButton(
                onPressed: onPressedHandler,
                icon: buttonContent,
              );
            }
          }

          return Container();
        },
      ),
    );
  }
}