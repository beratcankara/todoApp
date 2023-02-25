import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/models/taskModel.dart';
import 'pages/anaSayfa.dart';

final hiveLocator = GetIt.instance;
void setup() {
  hiveLocator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>("tasks");
  for (var element in taskBox.values) {
    if (element.createdAt.day != DateTime.now().day) {
      taskBox.delete(element.id);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupHive();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo App',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 0,
            color: Colors.transparent,
            actionsIconTheme: IconThemeData(color: Constants.lastColor),
          ),
        ),
        home: const anaSayfa());
  }
}
