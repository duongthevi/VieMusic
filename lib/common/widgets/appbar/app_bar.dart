import 'package:ct312h_project/common/helpers/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;
  final VoidCallback? onLeadingPressed;
  final IconData? leadingIcon;

  const BasicAppbar({
    this.title,
    this.hideBack = false,
    this.action,
    this.backgroundColor,
    this.onLeadingPressed,
    this.leadingIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPop = GoRouter.of(context).canPop();
    final bool showLeadingButton = !hideBack && (onLeadingPressed != null || canPop);

    final Color iconColor = context.isDarkMode ? Colors.white : Colors.black;
    final Color buttonColor = context.isDarkMode
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.06);

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 80,
      title: title ?? const Text(''),
      actions: [
        action ?? Container()
      ],
      leading: showLeadingButton
          ? IconButton(
        onPressed: () {
          if (onLeadingPressed != null) {
            onLeadingPressed!();
          } else if (canPop) {
            context.pop();
          }
        },
        icon: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: buttonColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            leadingIcon ?? Icons.arrow_back_ios_new,
            size: 18,
            color: iconColor,
          ),
        ),
      )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}