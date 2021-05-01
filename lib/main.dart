import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/blocs/blocs.dart';
import 'package:instagram_bloc/blocs/simple_bloc_observer.dart';
import 'package:instagram_bloc/config/custom_router.dart';
import 'package:instagram_bloc/config/size_config.dart';
import 'package:instagram_bloc/repositories/repositories.dart';
import 'package:instagram_bloc/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // overrides toString() method of classes that extend equatable
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>(
              create: (_) => AuthRepository(),
            ),
            RepositoryProvider<UserRepository>(
              create: (_) => UserRepository(),
            ),
            RepositoryProvider<StorageRepository>(
              create: (_) => StorageRepository(),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (context) => AuthBloc(
                  authRepository: context.read<AuthRepository>(),
                ),
              ),
            ],
            child: MaterialApp(
              title: 'Flutter Instagram Bloc',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                scaffoldBackgroundColor: Colors.grey[50],
                appBarTheme: AppBarTheme(
                  brightness: Brightness.light,
                  color: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.black),
                  textTheme: TextTheme(
                    headline6: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.textMultiplier * 1.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              onGenerateRoute: CustomRouter.onGenerateRoute,
              initialRoute: SplashScreen.routeName,
            ),
          ),
        );
      });
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
