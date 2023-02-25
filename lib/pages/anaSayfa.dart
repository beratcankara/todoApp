import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todoapp/constants/constants.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/taskModel.dart';
import 'package:todoapp/widgets/mysearchDelegate.dart';
import 'package:todoapp/widgets/taskWidget.dart';

class anaSayfa extends StatefulWidget {
  const anaSayfa({super.key});

  @override
  State<anaSayfa> createState() => _anaSayfaState();
}

class _anaSayfaState extends State<anaSayfa> {
  late String isim;
  late DateTime zaman;
  List<Task> _tumGorevler = [];
  late LocalStorage _localStorage;

  @override
  void initState() {
    _localStorage = hiveLocator<LocalStorage>();
    _getAllTaskFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainColor,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _showAddTaskBottonSheet(context),
          child: Text(
            "Bugün neler yapacaksın ?",
            style: Constants.titleTextStyle,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            iconSize: 36,
            onPressed: () {
              _showSearchPage();
            },
          ),
          const SizedBox(
            width: 15,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 36,
            onPressed: () {
              _showAddTaskBottonSheet(context);
            },
          ),
        ],
      ),
      body: _tumGorevler.isNotEmpty
          ? ListView.builder(
              itemCount: _tumGorevler.length,
              itemBuilder: (BuildContext context, int index) {
                var oAnkiEleman = _tumGorevler[index];
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
                    onDismissed: (direction) {
                      _tumGorevler.removeAt(index);
                      _localStorage.deleteTask(task: oAnkiEleman);
                      setState(() {});
                    },
                    child: taskWidget(
                      oAnkiGelenEleman: oAnkiEleman,
                    ));
              },
            )
          : Center(
              child: Text(
                "Hadi görev ekle !",
                style: Constants.titleTextStyle,
              ),
            ),
    );
  }

  void _showAddTaskBottonSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: MediaQuery.of(context).viewInsets,
          color: Constants.lightColor,
          child: ListTile(
              title: TextField(
            autofocus: true,
            onSubmitted: (value) {
              isim = value;
              Navigator.pop(context);
              DatePicker.showTimePicker(context, onConfirm: (time) {
                setState(() {
                  zaman = time;
                  var yeniGorev = Task.create(isim, zaman);
                  _tumGorevler.add(yeniGorev);
                  _localStorage.addTask(task: yeniGorev);
                });
              },
                  showSecondsColumn: false,
                  theme: const DatePickerTheme(
                      backgroundColor: Constants.lightColor,
                      doneStyle: TextStyle(
                          color: Constants.mainColor,
                          fontWeight: FontWeight.w600),
                      cancelStyle: TextStyle(color: Constants.secColor)));
            },
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              hintText: "Görev nedir ?",
              border: InputBorder.none,
            ),
          )),
        );
      },
    );
  }

  Future<void> _getAllTaskFromDB() async {
    _tumGorevler = await _localStorage.getAllTask();
    setState(() {});
  }

  Future<void> _showSearchPage() async {
    await showSearch(
        context: context, delegate: mysearchDelegate(_tumGorevler));
    _getAllTaskFromDB();
  }
}
