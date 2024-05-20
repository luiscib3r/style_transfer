import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/editor/editor.dart';
import 'package:style_transfer/home/home.dart';

class EditorView extends StatelessWidget {
  const EditorView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<StylerBloc>();
    final filterBloc = context.read<FilterBloc>();
    final picker = ImagePicker();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(),
                BlocConsumer<StylerBloc, StylerState>(
                  listenWhen: (prev, curr) => curr is StylerProcessError,
                  listener: (context, state) {
                    final failure = (state as StylerProcessError).failure;
                    context.showFailure(failure);
                  },
                  builder: (context, state) => switch (state) {
                    StylerProcessingImage(image: final image) => EditorImage(
                        image: image,
                        isLoading: true,
                      ),
                    StylerImageProcessed(image: final image) ||
                    StylerProcessError(image: final image) ||
                    StylerImageWithFilter(image: final image) =>
                      EditorImage(
                        image: image,
                      ),
                    _ => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              CupertinoIcons.home,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => HomePage.open(context),
                              child: Text(l10n.selectImage),
                            ),
                          ],
                        ),
                      ),
                  },
                ),
                const Row(children: [SizedBox(height: 64)]),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () => HomePage.open(context),
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: bloc.rotateLeft,
                        icon: const Icon(CupertinoIcons.rotate_left),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          final image = switch (bloc.state) {
                            StylerImageProcessed(image: final image) => image,
                            StylerImageWithFilter(original: final image) =>
                              image,
                            _ => null,
                          };

                          if (image != null) {
                            bloc.selectedFilter(image);
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.sparkles,
                          size: 48,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: bloc.rotateRight,
                        icon: const Icon(CupertinoIcons.rotate_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(
                    height: 124,
                    child: FilterControlls(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.color_filter),
            label: l10n.loadFilter,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.cloud_download),
            label: l10n.save,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.share),
            label: l10n.share,
          ),
        ],
        iconSize: 32,
        selectedItemColor: context.colors.primary,
        unselectedItemColor: context.colors.primary,
        unselectedFontSize: 14,
        onTap: (index) async {
          if (index == 0) {
            final file = await picker.pickImage(source: ImageSource.gallery);

            if (file != null) {
              final image = await file.readAsBytes();
              filterBloc.addFilter(image);
            }
          }

          if (index == 1) {
            await bloc.saveImage();
            if (!kIsWeb && context.mounted) {
              context.showInfo(l10n.imageSaved);
            }
          }

          if (index == 2) {
            await bloc.shareImage();
          }
        },
      ),
    );
  }
}
