import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mock_bloc_stream/core/config/config.dart';
import 'package:mock_bloc_stream/core/config/env/network_config.dart';
import 'package:mock_bloc_stream/core/config/router.dart';
import 'package:mock_bloc_stream/core/base/bloc_provider.dart';
import 'package:mock_bloc_stream/core/base/app_bloc.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart' as di;
import 'package:mock_bloc_stream/features/home/bloc/home_bloc.dart';
import 'package:mock_bloc_stream/features/home/home_page.dart';
import 'package:mock_bloc_stream/utils/color.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/styles.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig().configApp(buildMode: BuildMode.stagging);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use shared blocs

    return MultiBlocProvider(
      providers: <BlocProvider<BaseBloc>>[
        BlocProvider<AppBloc>(
          bloc: di.locator<AppBloc>(),
        ),

        /// General
        BlocProvider<HomeBloc>(
          bloc: di.locator<HomeBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Movie App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: ColorConstant.kRichBlack,
          scaffoldBackgroundColor: ColorConstant.kRichBlack,
          textTheme: StylesConstant.kTextTheme,
          colorScheme: ColorConstant.kColorScheme.copyWith(
            secondary: Colors.redAccent,
          ),
        ),
        builder: EasyLoading.init(),
        home: const HomePage(),
        navigatorObservers: <NavigatorObserver>[routeObserver],
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
