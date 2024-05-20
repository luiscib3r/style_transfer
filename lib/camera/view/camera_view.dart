import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/editor/editor.dart';
import 'package:style_transfer/home/home.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  late final StylerBloc bloc = context.read();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeCameraController(cameraController.description);
    }
  }

  Future<void> init() async {
    cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      await onNewCameraSelected(cameras.first);
    } else {
      if (mounted) {
        context.showError('No cameras found.');
      }
    }
  }

  Future<void> initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    final cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );

    controller = cameraController;

    cameraController.addListener(() {
      if (cameraController.value.hasError) {
        context.showError(
          'Camera error ${cameraController.value.errorDescription}',
        );
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          if (mounted) {
            context.showError('You have denied camera access.');
          }

        case 'CameraAccessDeniedWithoutPrompt':
          if (mounted) {
            context.showError(
              'Please go to Settings app to enable camera access.',
            );
          }

        case 'CameraAccessRestricted':
          if (mounted) {
            context.showError('Camera access is restricted.');
          }

        case 'AudioAccessDenied':
          if (mounted) {
            context.showError('You have denied audio access.');
          }

        case 'AudioAccessDeniedWithoutPrompt':
          if (mounted) {
            context
                .showError('Please go to Settings app to enable audio access.');
          }

        case 'AudioAccessRestricted':
          if (mounted) {
            context.showError('Audio access is restricted.');
          }

        default:
          context.showError('Error: ${e.code}\n${e.description}');
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.setDescription(cameraDescription);
    } else {
      return initializeCameraController(cameraDescription);
    }
  }

  IconData getCameraLensIcon(CameraLensDirection direction) =>
      switch (direction) {
        CameraLensDirection.back => Icons.camera_rear,
        CameraLensDirection.front => Icons.camera_front,
        CameraLensDirection.external => Icons.camera,
      };

  @override
  Widget build(BuildContext context) {
    final camera = controller != null && controller!.value.isInitialized
        ? controller!.value
        : null;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = camera != null ? size.aspectRatio * camera.aspectRatio : 1.0;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return BlocListener<StylerBloc, StylerState>(
      listenWhen: (previous, current) => current is StylerProcessingImage,
      listener: (context, state) => EditorPage.open(context),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (controller != null)
              Transform.scale(
                scale: kIsWeb ? 1 : scale,
                child: Center(
                  child: CameraPreview(controller!),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () => HomePage.open(context),
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 64,
                          color: context.colors.primary,
                          onPressed: () async {
                            try {
                              final file = await controller?.takePicture();

                              if (file != null) {
                                final image = await file.readAsBytes();
                                bloc.selectImage(image);
                              }
                            } catch (e) {
                              log(e.toString());
                            }
                          },
                          icon: const Icon(Icons.camera),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: cameras
                          .map(
                            (camera) => IconButton(
                              onPressed: () => onNewCameraSelected(camera),
                              icon: Icon(
                                getCameraLensIcon(camera.lensDirection),
                                size: 32,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
