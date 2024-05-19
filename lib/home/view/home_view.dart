import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/editor/editor.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final picker = ImagePicker();
    final bloc = context.read<StylerBloc>();

    return BlocListener<StylerBloc, StylerState>(
      listenWhen: (previous, current) => current is StylerProcessingImage,
      listener: (context, state) => EditorPage.open(context),
      child: Scaffold(
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
          onTap: (index) async {
            switch (index) {
              case 0:
                final file =
                    await picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  final image = await file.readAsBytes();
                  bloc.selectImage(image);
                }
              case 1:
                log('Selected Camera');
              case _:
                break;
            }
          },
        ),
      ),
    );
  }
}
