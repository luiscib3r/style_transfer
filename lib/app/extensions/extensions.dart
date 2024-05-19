import 'package:style_transfer/app/app.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  ThemeData get theme => Theme.of(this);
  TextTheme get texts => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;

  void showError(Failure failure) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(_getFailureMessage(failure)),
        backgroundColor: colors.error,
      ),
    );
  }

  String _getFailureMessage(Failure failure) {
    return switch (failure) {
      UnknownFailure(exception: final ex) => ex.toString(),
      ImageResizeFailure() => l10n.imageResizeFailure,
      ImageDecodeFailure() => l10n.imageDecodeFailure,
    };
  }
}
