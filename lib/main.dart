import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lloo_mobile/app/modules/lloo_read/lloo_read_module.dart';
import 'package:lloo_mobile/app/modules/user/user_module.dart';
import 'package:lloo_mobile/app/core/global_bindings.dart';
import 'package:lloo_mobile/app/modules/wallet/wallet_module.dart';
import 'package:lloo_mobile/app/modules/onboarding/onboarding_module.dart';
import 'package:magic_sdk/magic_sdk.dart';
import 'app/core/lloo_exceptions.dart';
import 'app/modules/user/user_state.dart';
import 'app/navigation.dart';
import 'app/app_routes.dart';
import 'app/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'app/debug/debug.dart';
import 'app/temp_view.dart';
import 'firebase_options.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;


import 'package:flutter/rendering.dart';

// @TODO: Clean upo the stuff below that was attempting to help hot restarts (but didn't work)

void main() async {
  debugPaintSizeEnabled = false; // Enable widget borders

  // FIREBASE INIT
  // @TODO: Needed?
  WidgetsFlutterBinding.ensureInitialized();


  // INIT CORE AND MODULES
  // These can throw
  try {
    await GlobalBindings().initDependencies();

    // INIT THE MODULES
    // This should be the only place top level needs to explicitly
    // reference the modules
    llooReadModuleInit();
    walletModuleInit();
    userModuleInit();
    onboardingModuleInit();
  } on LlooException catch (e) {
    L.error("MAIN", "Error initializing modules: $e");
    // @TODO: Set some sort of global state flag to show error once widget loads
    rethrow;
  }

  $appRoutes.initialRoute = $appRoutes.llooRead.home;


  // DEBUGGING TOOLS SETUP
  await debugDoStartupMainDebugActions();

  // LAUNCH APP
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

//
// /// Wrapper to ensure hot reload works
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   // prevent duplicate view errors on hot reload
//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     Get.delete();  // Clear GetX controllers
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.detached) {
//       Get.delete();
//     }
//   }

  @override
  Widget build(BuildContext context) {
    //   SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(
    //       statusBarColor: Colors.white,
    //       statusBarIconBrightness: Brightness.dark,  // For Android
    //       statusBarBrightness: Brightness.light,     // For iOS
    //     ),
    //   );
    //
    //   return GetMaterialApp(
    //     title: 'Cue2Lit Search',
    //     navigatorKey: navigatorKey,
    //     theme: AppTheme.light,
    //     darkTheme: AppTheme.dark,
    //     defaultTransition: Transition.native,
    //     getPages: $appRoutes.routes,
    //     initialRoute: $appRoutes.initialRoute,
    //     navigatorObservers: [
    //       LlooNavigationObserver()
    //     ],
    //     onInit: () {
    //       // Clear any existing platform views
    //       SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    //     },
    //   );
    // }
    return MaterialApp(
      title: 'Magic.link Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Stack(
          children: [
            const LoginScreen(),
            Magic.instance.relayer
          ]
      ),
    );
  }
}
