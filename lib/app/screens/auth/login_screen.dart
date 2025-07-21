import 'package:agro_sav/app/controllers/auth_controller.dart';
import 'package:agro_sav/app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 32),
                Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: authController.emailController,
                  labelText: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                Obx(() => CustomTextField(
                      controller: authController.passwordController,
                      labelText: "Password",
                      icon: Icons.lock,
                      obscureText: authController.obscurePassword.value,
                      suffixIcon: IconButton(
                        icon: Icon(authController.obscurePassword.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: authController.togglePasswordVisibility,
                      ),
                    )),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authController.loginWithEmail();
                    }
                  },
                  child: const Text("Login"),
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/signup'),
                  child: const Text("Don't have an account? Sign up"),
                ),
                const Divider(height: 40),
                ElevatedButton.icon(
                  onPressed: () {
                    authController.signInWithGoogle();
                  },
                  icon: const Icon(Icons.login),
                  label: const Text("Login with Google"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
