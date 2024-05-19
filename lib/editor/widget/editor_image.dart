import 'dart:typed_data';

import 'package:style_transfer/app/app.dart';

class EditorImage extends StatelessWidget {
  const EditorImage({
    required this.image,
    this.isLoading = false,
    super.key,
  });

  final bool isLoading;
  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.memory(
          image,
          width: 384,
          height: 384,
        ),
        if (isLoading) const CircularProgressIndicator(),
      ],
    );
  }
}
