
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/platform_model.dart';
import 'package:myapp/providers/platform_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class PlatformManagementScreen extends StatelessWidget {
  const PlatformManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final platformProvider = context.watch<PlatformProvider>();
    final platforms = platformProvider.platforms;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/settings');
            }
          },
        ),
        title: const Text('Mis Plataformas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showPlatformDialog(context, platformProvider),
          ),
        ],
      ),
      body: platformProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : platforms.isEmpty
              ? const Center(child: Text('No tienes plataformas registradas.'))
              : ListView.builder(
                  itemCount: platforms.length,
                  itemBuilder: (context, index) {
                    final platform = platforms[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: ListTile(
                        title: Text(platform.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showPlatformDialog(context, platformProvider, platform: platform),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => platformProvider.deletePlatform(platform.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },), 
    );
  }

  void _showPlatformDialog(BuildContext context, PlatformProvider provider, {Platform? platform}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: platform?.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(platform == null ? 'Añadir Plataforma' : 'Editar Plataforma'),
        content: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre de la Plataforma'),
              validator: (value) => (value == null || value.isEmpty) ? 'Campo requerido' : null,
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final currentUserId = provider.userId;
                if (currentUserId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error: Usuario no identificado. No se puede guardar.')),
                  );
                  return;
                }

                final newPlatform = Platform(
                  id: platform?.id ?? const Uuid().v4(),
                  userId: currentUserId, 
                  name: nameController.text,
                );

                if (platform == null) {
                  provider.addPlatform(newPlatform);
                } else {
                  provider.updatePlatform(newPlatform);
                }
                Navigator.of(context).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
