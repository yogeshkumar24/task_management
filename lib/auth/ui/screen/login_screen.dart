import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/auth/ui/screen/sign_up.dart';
import 'package:task_management/auth/view_model/auth_provider.dart';
import 'package:task_management/dashboard/ui/dashboard.dart';
import 'package:task_management/shared/constants/string_const.dart';
import 'package:task_management/shared/validators.dart';
import 'package:task_management/shared/widget/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
                key: _formKey,
                child: Consumer<AuthProvider>(
                    builder: (BuildContext context, authProvider, child) {
                  return Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            StringConstant.email,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                            controller: authProvider.emailController,
                            validator: (value) {
                              return Validator.emailValidator(value);
                            },
                            hintText: StringConstant.email,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            StringConstant.password,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          CustomTextField(
                              controller: authProvider.passwordController,
                              validator: (value) {
                                return Validator.nameValidator(
                                    value, StringConstant.password);
                              },
                              hintText: StringConstant.password,
                              obscureText: authProvider.showPassword,
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    authProvider.updatePasswordField();
                                  },
                                  child: Icon(!authProvider.showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off))),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text("Use Email: eve.holt@reqres.in"),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                await login(authProvider, context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(StringConstant.loginButtonText),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(StringConstant.createAccount),
                          ),
                        ],
                      ),
                      if (authProvider.isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                    ],
                  );
                }))));
  }

  Future<void> login(AuthProvider authProvider, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      bool value = await authProvider.login(context);
      if (value) {
        authProvider.clearFields();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      }
    }
  }

}
