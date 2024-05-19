import 'package:style_transfer/app/app.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  ThemeData get theme => Theme.of(this);
  TextTheme get texts => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;
}
