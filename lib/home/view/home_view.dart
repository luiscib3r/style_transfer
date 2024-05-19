import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:style_transfer/app/app.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Assets.images.banner.image(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        unselectedFontSize: 14,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.primary,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.photo_fill),
            label: l10n.gallery,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.camera_fill),
            label: l10n.camera,
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              log('Selected Gallery');
            case 1:
              log('Selected Camera');
            case _:
              break;
          }
        },
      ),
    );
  }
}
