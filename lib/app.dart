import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futter_user_list_cubit/user_list/cubit/user_list_cubit.dart';
import 'package:futter_user_list_cubit/user_list/view/user_list_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "User List",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 255, 0, 0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // Enable scroll behavior by other devices on web
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      home: BlocProvider(
        create: (context) => UserListCubit()..fetchUser(),
        child: const UserListPage(),
      ),
    );
  }
}
