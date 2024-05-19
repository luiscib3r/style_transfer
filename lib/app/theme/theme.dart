import 'package:google_fonts/google_fonts.dart';
import 'package:style_transfer/app/app.dart';

part 'colors.dart';

final _baseTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    tertiary: AppColors.success,
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 30, 33, 33),
);

final appTheme = _baseTheme.copyWith(
  textTheme: GoogleFonts.ubuntuTextTheme(_baseTheme.textTheme),
);
