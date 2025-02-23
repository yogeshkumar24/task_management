import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/auth/ui/screen/login_screen.dart';
import 'package:task_management/profile/data/model/user_model.dart';
import 'package:task_management/profile/ui/user_details.dart';
import 'package:task_management/profile/view_model/profile_provider.dart';
import 'package:task_management/shared/constants/string_const.dart';
import 'package:task_management/shared/util/storage_helper.dart';
import 'package:task_management/shared/widget/custom_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: StringConstant.allUsers,
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(
            onPressed: () {
              StorageHelper().saveIsLoggedIn(false);
              StorageHelper().clearAll();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
            return profileProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.separated(
                    itemCount: profileProvider.userList.length,
                    itemBuilder: (context, index) {
                      User user = profileProvider.userList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetails(id: user.id!),
                              ));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(user.firstName!),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(user.lastName!)
                              ],
                            ),
                            Text(user.email!),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  );
          })),
    );
  }
}
