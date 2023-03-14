import 'package:flutter/material.dart';
import 'package:notes_app/consts/routes.dart';
import 'package:notes_app/enums/menu_action.dart';
import 'package:notes_app/services/auth/auth_service.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if(shouldLogout){
                      await AuthService.firebase().signOut();
                      Navigator.of(context).
                      pushNamedAndRemoveUntil(loginRoute, (route) => false);
                    }
                }
              }, itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text("Logout"))
                ];
          }),
        ],
      ),
      body: Container(),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: const Text("Cancel")),
          TextButton(onPressed: (){
            Navigator.of(context).pop(true);
          }, child: const Text("Logout"))
        ],
      );
    },).then((value) => value ?? false);
}
