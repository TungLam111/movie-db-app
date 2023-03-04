import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mock_bloc_stream/core/config/config.dart';
import 'package:mock_bloc_stream/core/config/env/network_config.dart';
import 'package:mock_bloc_stream/core/config/firebase/config.dart';
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

//keytool -genkey -v -keystore ~/upload-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storetype JKS
//keytool -v -list -keystore mykeystore.jks

main() async {
  await AppConfig().configApp(buildMode: BuildMode.stagging);
  await FirebaseConfiguration.initFirebaseConfiguration();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    FirebaseConfiguration.initEvent(context);

    super.didChangeDependencies();
  }

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
