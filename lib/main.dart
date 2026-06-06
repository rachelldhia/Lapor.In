import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/report/presentation/bloc/report_bloc.dart';
import 'features/report/presentation/bloc/report_event.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(
          create: (_) => di.sl<ReportBloc>()..add(const LoadReports()),
        ),
      ],

      child: MaterialApp(
        title: 'Lapor.In',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
      ),
    );
  }
}
