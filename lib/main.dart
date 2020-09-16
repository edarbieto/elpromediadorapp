import 'package:elpromediadorapp/screens/login.dart';
import 'package:elpromediadorapp/screens/notas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme.light(),
        AppTheme.dark(),
        AppTheme(
          id: 'login',
          description: 'Login theme',
          data: ThemeData(
            primarySwatch: Colors.red,
            textSelectionColor: Colors.red,
            textSelectionHandleColor: Colors.red,
          ),
        ),
      ],
      child: MaterialApp(
        // theme: ThemeProvider.themeOf(context).data,
        title: 'El Promediador',
        routes: {
          Login.routeName: (context) => Login(),
          Notas.routeName: (context) => Notas(ModalRoute.of(context).settings.arguments),
        },
        initialRoute: '/',
        // home: Notas(),
      ),
    );
  }
}
