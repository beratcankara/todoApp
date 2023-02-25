import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/widgets/taskWidget.dart';

import '../models/taskModel.dart';

class mysearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  mysearchDelegate(this.allTask);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        scaffoldBackgroundColor: Constants.mainColor,
        hintColor: Constants.lastColor,
        inputDecorationTheme: InputDecorationTheme(border: InputBorder.none));
  }

  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Constants.lastColor,
        ),
        onPressed: () {
          query.isEmpty ? null : query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      color: Constants.lightColor,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask
        .where((oAnkiGorev) =>
            oAnkiGorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (BuildContext context, int index) {
              var oAnkiEleman = filteredList[index];
              return Dismissible(
                key: Key(oAnkiEleman.id),
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      const Icon(Icons.delete,
                          size: 24, color: Constants.lastColor),
                      const SizedBox(width: 15),
                      Text(
                        "Bu görev siliniyor.",
                        style: Constants.labelTextStyle(24, false),
                      ),
                    ],
                  ),
                ),
                onDismissed: (direction) async {
                  filteredList.removeAt(index);
                  await hiveLocator<LocalStorage>()
                      .deleteTask(task: oAnkiEleman);
                  await hiveLocator<LocalStorage>()
                      .updateTask(task: oAnkiEleman);
                },
                child: taskWidget(
                  oAnkiGelenEleman: oAnkiEleman,
                ),
              );
            },
          )
        : Center(
            child: Text("Aradığınızı bulamadık"),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.red,
    );
  }

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => "Lütfen aramak istediginiz görevi yazınız";

  @override
  // TODO: implement searchFieldStyle
  TextStyle? get searchFieldStyle => TextStyle(
        color: Constants.lastColor,
        fontFamily: GoogleFonts.odibeeSans().fontFamily,
        fontSize: 22,
      );
}
