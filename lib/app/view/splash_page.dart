
import 'package:flutter/material.dart';
import 'package:yansnet/app/widgets/splash_logo.dart';
// import 'package:yansnet/core/utils/pref_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      // final sessionId = await PrefUtils().getAuthToken();
      debugPrint('starting to get token from cache storage');

      try{
        //TODO (camcoder): initialize app user config throught fetchs via cubits
        //TODO (camcoder): init timeago, rabbit and notification services


        //TODO (camcoder): fetch user informations
        // unawaited(
        //   context.pushNamed("home"),
        // );


      } on Exception catch(e){
        debugPrint('Some splash initiations failed: $e');
        // unawaited(
        //   context.pushNamed("home"),
        // );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SplashLogo(),
      ),
    );
  }
}
