import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/utils/show_snackbar.dart';

import 'package:planit/viewmodels/auth_viewmodel.dart';
import 'package:planit/views/home_page.dart';
import 'package:planit/views/widgets/auth_gradient_page.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (_) => false,
          );
        },

        error: (error, st) {
          showSnackBar(context, error.toString(), SnackBarType.error);
        },

        loading: () {},
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create Account",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),
                Text(
                  "Create new account to get started and enjoy seamless access to our features",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),

                SizedBox(height: 50),

                //Name filed
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email address",
                    prefixIcon: Icon(Icons.email_rounded),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                //Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                //Confirm password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _isConfirmPasswordHidden,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                        });
                      },
                      icon: Icon(
                        _isConfirmPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return " Enter confirm password";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.9, // Make it wide
                  height: 70,
                  child: AuthGradientPage(
                    buttonText: 'Create Account',
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await ref
                            .read(authViewModelProvider.notifier)
                            .signupUser(
                              userName: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                      } else {
                        showSnackBar(
                          context,
                          "Fill missing fields",
                          SnackBarType.error,
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      children: const [
                        TextSpan(
                          text: 'Sign in here',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
