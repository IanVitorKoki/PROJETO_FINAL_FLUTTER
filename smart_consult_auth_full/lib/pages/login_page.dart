import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  final supabase = Supabase.instance.client;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await supabase.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Consult - Login")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.medical_services_outlined, size: 70),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: "E-mail"),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Informe o e-mail";
                      if (!value.contains("@")) return "E-mail inválido";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Senha"),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Informe a senha";
                      if (value.length < 6) return "Mínimo 6 caracteres";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading ? const CircularProgressIndicator() : const Text("Entrar"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
                    child: const Text("Criar conta"),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Time: Ian, Henrique Peters e Luiz Barbosa",
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
