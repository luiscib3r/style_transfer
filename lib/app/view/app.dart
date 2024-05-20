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
        styleTransferRepository,
      ],
      child: Builder(
        builder: (context) {
          return FutureBuilder(
            future: Future.wait([
              StylerBlocImpl.start(repository: context.read()),
              FilterBlocImpl.start(repository: context.read()),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data! as List<Object>;

                return MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider<StylerBloc>.value(
                      value: data[0] as StylerBloc,
                    ),
                    RepositoryProvider<FilterBloc>.value(
                      value: data[1] as FilterBloc,
                    ),
                  ],
                  child: MaterialApp.router(
                    theme: appTheme,
                    routerConfig: appRouter,
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    debugShowCheckedModeBanner: false,
                  ),
                );
              }

              return MaterialApp(
                theme: appTheme,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      if (snapshot.hasError)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.error.toString(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
