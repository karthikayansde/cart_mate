import 'package:cart_mate/utils/app_strings.dart';
import 'package:cart_mate/views/feedback_view.dart';
import 'package:cart_mate/views/update_view.dart';
import 'package:flutter/material.dart';

class SideDrawerView extends StatelessWidget {
  const SideDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/animatedBg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Row(
                children: [
                  Column(
                    children: [

                      Image.asset(
                        'assets/images/cartmateLogo.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 3),
                      // App name or user name.
                      const Text(
                        AppStrings.appName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Align( alignment: Alignment.topRight, child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close, color: Colors.black, size: 30,),))
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(AppStrings.editProfile),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return UpdateView();
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              // Handle the action for "Change Password".
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: const Text('Delete Account'),
            onTap: () {
              // Handle the action for "Delete Account".
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              // Handle the action for "Logout".
              Navigator.pop(context);

            },
          ),
          // A Divider to separate main options from support/feedback options.
          const Divider(),
          // Support and feedback options.
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text(AppStrings.helpFeedback),
            onTap: () {
              // Handle the action for "Help and Feedback".
              Navigator.pop(context);
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return FeedbackView();
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Enjoying? Rate us!'),
            onTap: () {
              // Handle the action for "Rate Us".
              // This could open a dialog or redirect to the app store.
              Navigator.pop(context);
              // You could show a custom dialog here, for example:
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return AlertDialog(
              //       title: const Text('Rate Us'),
              //       content: const Text('Please rate us on the app store!'),
              //       actions: <Widget>[
              //         TextButton(
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //           child: const Text('OK'),
              //         ),
              //       ],
              //     );
              //   },
              // );
            },
          ),
        ],
      ),
    );
  }
}
