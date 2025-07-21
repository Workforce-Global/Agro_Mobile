import 'package:agro_sav/app/controllers/auth_controller.dart';
import 'package:agro_sav/app/widgets/custom_button.dart';
import 'package:agro_sav/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _firstName = TextEditingController();
  final _lastName  = TextEditingController();
  final _email     = TextEditingController();
  final _password  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                labelText: "First Name",
                controller: _firstName,
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: "Last Name",
                controller: _lastName,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: "Email",
                controller: _email,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Obx(() => CustomTextField(
                    labelText: "Password",
                    controller: _password,
                    icon: Icons.lock,
                    obscureText: authController.obscurePassword.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        authController.obscurePassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: authController.togglePasswordVisibility,
                    ),
                  )),
              const SizedBox(height: 24),
              CustomButton(
                text: "Register",
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    authController.signUp(
                      _email.text.trim(),
                      _password.text.trim(),
                      _firstName.text.trim(),
                      _lastName.text.trim(),
                    );
                  }
                },
              ),
              TextButton(
                onPressed: () => Get.back(), // navigate back to Login
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
