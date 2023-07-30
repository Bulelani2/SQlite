import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:units_reflection/Models/reflection.dart';
import 'package:units_reflection/Models/units.dart';
import 'package:units_reflection/Models/user.dart';
import 'package:units_reflection/Services/unit_reflection_service.dart';
import 'package:units_reflection/Services/user_service.dart';
import 'package:units_reflection/Widgets/dailogs.dart';

class UnitReflectionPage extends StatefulWidget {
  const UnitReflectionPage({super.key});

  @override
  State<UnitReflectionPage> createState() => _UnitReflectionPageState();
}

class _UnitReflectionPageState extends State<UnitReflectionPage> {
  late TextEditingController todoController;

  @override
  void initState() {
    super.initState();
    todoController = TextEditingController();
  }

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<UnitData>().fetchData;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text('Create a new TODO'),
                              content: TextField(
                                decoration: const InputDecoration(
                                    hintText: 'Please enter TODO'),
                                controller: todoController,
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('Save'),
                                  onPressed: () async {
                                    if (todoController.text.isEmpty) {
                                      showSnackBar(
                                          context, "Please enter a Reflection");
                                    } else {
                                      String username = await context
                                          .read<UserService>()
                                          .currentUser
                                          .username;
                                      Reflection reflection = Reflection(
                                          username: username,
                                          title: todoController.text.trim(),
                                          created: DateTime.now());
                                      if (context
                                          .read<ReflectionService>()
                                          .reflection
                                          .contains(reflection)) {
                                        showSnackBar(
                                            context, "Reflection Exist!!");
                                      } else {
                                        String results = await context
                                            .read<ReflectionService>()
                                            .createReflections(reflection);
                                        if (results == "OK") {
                                          showSnackBar(
                                              context, "Reflection Added");
                                          todoController.text = "";
                                        } else {
                                          showSnackBar(context, results);
                                        }
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Selector<UserService, User>(
                  selector: (context, value) => value.currentUser,
                  builder: (context, value, child) {
                    return Text(
                      '${value.name}\'s Todo list',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                  child: Consumer<ReflectionService>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        itemCount: value.reflection.length,
                        itemBuilder: (context, index) {
                          return Container();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
