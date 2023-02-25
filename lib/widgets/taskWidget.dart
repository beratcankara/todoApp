import 'package:flutter/material.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/main.dart';

import '../constants/constants.dart';
import '../models/taskModel.dart';

class taskWidget extends StatefulWidget {
  final Task oAnkiGelenEleman;
  const taskWidget({super.key, required this.oAnkiGelenEleman});

  @override
  State<taskWidget> createState() => _taskWidgetState();
}

class _taskWidgetState extends State<taskWidget> {
  var oAnkiEleman;
  late LocalStorage _localStorage;

  @override
  void initState() {
    _localStorage = hiveLocator<LocalStorage>();
    oAnkiEleman = widget.oAnkiGelenEleman;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Constants.secColor,
          border: Border.all(),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              blurStyle: BlurStyle.outer,
              color: Constants.secColor,
            ),
          ],
        ),
        child: ListTile(
          leading: IconButton(
            icon: const Icon(Icons.check),
            color: widget.oAnkiGelenEleman.isCompleted
                ? Constants.lastColor
                : Constants.lightColor.withOpacity(0.2),
            onPressed: () {
              setState(() {
                widget.oAnkiGelenEleman.isCompleted =
                    !widget.oAnkiGelenEleman.isCompleted;
              });
            },
          ),
          textColor: Colors.white,
          title: TextField(
            minLines: 1,
            maxLines: null,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(border: InputBorder.none),
            controller: TextEditingController(text: oAnkiEleman.name),
            style: Constants.labelTextStyle(
                24, widget.oAnkiGelenEleman.isCompleted),
            onSubmitted: (value) {
              widget.oAnkiGelenEleman.name = value;
              _localStorage.updateTask(task: oAnkiEleman);
            },
          ),
          trailing: Text(
            "${oAnkiEleman.createdAt.hour.toString()} . ${oAnkiEleman.createdAt.minute.toString()}",
            style: Constants.labelTextStyle(
                24, widget.oAnkiGelenEleman.isCompleted),
          ),
        ),
      ),
    );
  }
}
