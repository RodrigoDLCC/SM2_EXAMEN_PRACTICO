import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear usuario en Firestore
  Future<void> crearUsuario({
    required String userId,
    required String username,
    required String email,
    required String nombreCompleto,
    required String rol,
  }) async {
    try {
      await _firestore.collection('usuarios').doc(userId).set({
        'username': username,
        'email': email,
        'nombreCompleto': nombreCompleto,
        'rol': rol,
        'fecha_creacion': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Error al crear usuario: ${e.toString()}');
    }
  }

  // Obtener todos los usuarios
  Stream<List<Map<String, dynamic>>> obtenerUsuarios() {
    return _firestore.collection('usuarios').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      },
    );
  }

  // Actualizar usuario
  Future<void> actualizarUsuario({
    required String userId,
    String? username,
    String? nombreCompleto,
    String? rol,
  }) async {
    try {
      Map<String, dynamic> datosActualizados = {};
      if (username != null) datosActualizados['username'] = username;
      if (nombreCompleto != null) datosActualizados['nombreCompleto'] = nombreCompleto;
      if (rol != null) datosActualizados['rol'] = rol;

      await _firestore.collection('usuarios').doc(userId).update(datosActualizados);
    } catch (e) {
      throw Exception('Error al actualizar usuario: ${e.toString()}');
    }
  }

  // Eliminar usuario
  Future<void> eliminarUsuario(String userId) async {
    try {
      await _firestore.collection('usuarios').doc(userId).delete();
    } catch (e) {
      throw Exception('Error al eliminar usuario: ${e.toString()}');
    }
  }
}
