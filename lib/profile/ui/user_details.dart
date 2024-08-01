import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/profile/view_model/profile_provider.dart';
import 'package:task_management/shared/widget/custom_app_bar.dart';

class UserDetails extends StatefulWidget {
  int id;

  UserDetails({required this.id, super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    Future.delayed(Duration.zero, () async {
      Provider.of<ProfileProvider>(context, listen: false)
          .getUser(context, widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'User',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProfileProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            return provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${provider.user?.firstName ?? ''}"),
                      Text("Email: ${provider.user?.email ?? ''}"),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
