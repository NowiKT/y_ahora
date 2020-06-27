import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:y_ahora/login/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:y_ahora/login/repository/user_repository.dart';
import 'package:y_ahora/login/ui/home_screen.dart';
import 'package:y_ahora/login/ui/splash_screen.dart';

import 'login/bloc/authentication_bloc/authentication_event.dart';
import 'login/bloc/authentication_bloc/authentication_state.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AppStarted()),
      child: App(userRepository: userRepository),
    )
  );
}

class App extends StatelessWidget{
  final UserRepository _userRepository;
  App({Key key, @required UserRepository userRepository})
    :assert (userRepository != null),
    _userRepository = userRepository,
    super(key: key);
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
       home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
         builder: (context, state){
           if (state is Uninitialized){
             return SplashScreen();
           }
           if (state is Authenticated){
             return HomeScreen(name: state.displayName,);
           }
           if(state is Unauthenticated){
             return Container(color: Colors.orange);
           }
           return Container();
         },
       ),
     );
    }
  }
