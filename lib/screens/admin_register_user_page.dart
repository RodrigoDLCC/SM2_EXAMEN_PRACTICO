import 'package:flutter/material.dart';
import 'package:proyecto_moviles2/services/auth_service.dart';

class AdminRegisterUserPage extends StatefulWidget {
  const AdminRegisterUserPage({super.key});

  @override
  State<AdminRegisterUserPage> createState() => _AdminRegisterUserPageState();
}

class _AdminRegisterUserPageState extends State<AdminRegisterUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  String email = '';
  String username = '';
  String nombreCompleto = '';
  String password = '';
  String rol = 'usuario'; // o 'admin'

  bool loading = false;
  String mensaje = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre completo'),
                onChanged: (val) => nombreCompleto = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                onChanged: (val) => username = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (val) => email = val,
                validator: (val) =>
                    val == null || !val.contains('@') ? 'Email inválido' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                onChanged: (val) => password = val,
                validator: (val) =>
                    val != null && val.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              DropdownButtonFormField<String>(
                value: rol,
                decoration: InputDecoration(labelText: 'Rol'),
                items: const [
                  DropdownMenuItem(value: 'usuario', child: Text('Usuario')),
                  DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                ],
                onChanged: (val) => setState(() => rol = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                            mensaje = '';
                          });
                          final result = await _authService.registerUser(
                            username: username,
                            email: email,
                            password: password,
                            nombreCompleto: nombreCompleto,
                            rol: rol,
                          );
                          setState(() {
                            loading = false;
                            mensaje = result != null
                                ? 'Usuario registrado correctamente.'
                                : 'Error al registrar usuario.';
                          });
                        }
                      },
                child: Text(loading ? 'Registrando...' : 'Registrar Usuario'),
              ),
              if (mensaje.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    mensaje,
                    style: TextStyle(
                        color: mensaje.contains('correctamente')
                            ? Colors.green
                            : Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
