import 'package:style_transfer/app/app.dart';
import 'package:style_transfer/app/bloc/filter/isolate/filter_bloc_isolate.dart'
    if (dart.library.html) 'package:style_transfer/app/bloc/filter/worker/filter_bloc_worker.dart';
import 'package:style_transfer/app/bloc/styler/isolate/styler_bloc_isolate.dart'
    if (dart.library.html) 'package:style_transfer/app/bloc/styler/worker/styler_bloc_worker.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        imageDataSource,
        stylerDataSource,
        styleTransferRepository,
      ],
      child: const _App(),
    );
  }
}

class _App extends StatefulWidget {
  const _App();

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  List<Object>? blocs;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    blocs = await Future.wait([
      StylerBlocImpl.start(repository: context.read()),
      FilterBlocImpl.start(repository: context.read()),
    ]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (blocs == null) {
      return const _AppLoading();
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StylerBloc>.value(
          value: blocs![0] as StylerBloc,
        ),
        RepositoryProvider<FilterBloc>.value(
          value: blocs![1] as FilterBloc,
        ),
      ],
      child: MaterialApp.router(
        theme: appTheme,
        routerConfig: appRouter,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _AppLoading extends StatelessWidget {
  const _AppLoading();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
