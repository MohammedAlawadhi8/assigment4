import 'package:flutter/material.dart';
import 'package:assignment2/services/auth_firebase.dart';
import 'package:assignment2/screens/home_screen.dart';
import 'package:assignment2/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:assignment2/services/auth_firebase.dart';
import 'package:assignment2/screens/home_screen.dart';
import 'package:assignment2/screens/login/login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthFirebase auth = AuthFirebase();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إنشاء حساب"), centerTitle: true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 8),
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person_add, size: 48, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'اسم المستخدم',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'أدخل اسم المستخدم' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'أدخل البريد الإلكتروني';
                            if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$").hasMatch(v)) return 'بريد إلكتروني غير صحيح';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 6) ? 'الحد الأدنى 6 أحرف' : null,
                        ),
                        const SizedBox(height: 20),
                        isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) return;

                                    setState(() => isLoading = true);

                                    final user = await auth.register(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                      username: _usernameController.text.trim(),
                                    );

                                    setState(() => isLoading = false);

                                    if (user != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم التسجيل بنجاح")));
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("فشل التسجيل")));
                                    }
                                  },
                                  child: const Text('إنشاء حساب', style: TextStyle(fontSize: 16)),
                                ),
                              ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                          },
                          child: const Text('هل لديك حساب؟ تسجيل الدخول', style: TextStyle(color: Colors.black54)),
                        ),
                      ],
                    ),
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