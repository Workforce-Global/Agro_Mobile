import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool allGranted = false;

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.location,
    ].request();

    setState(() {
      allGranted = statuses.values.every((status) => status.isGranted);
    });

    if (allGranted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed('/dashboard');
      });
    }
  }

  Widget buildPermissionTile(String title, IconData icon, Permission permission) {
    return FutureBuilder<PermissionStatus>(
      future: permission.status,
      builder: (context, snapshot) {
        final status = snapshot.data;
        final isGranted = status == PermissionStatus.granted;

        return Card(
          child: ListTile(
            leading: Icon(icon, color: isGranted ? Colors.green : Colors.red),
            title: Text(title),
            trailing: isGranted
                ? const Icon(Icons.check_circle, color: Colors.green)
                : ElevatedButton(
                    onPressed: () async {
                      final result = await permission.request();
                      if (result.isGranted) checkPermissions();
                    },
                    child: const Text("Allow"),
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Permissions Required"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "To proceed, AgroSavior needs the following permissions:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            buildPermissionTile("Camera", Icons.camera_alt, Permission.camera),
            buildPermissionTile("Files and Storage", Icons.folder, Permission.storage),
            buildPermissionTile("Location", Icons.location_on, Permission.location),
            const Spacer(),
            if (!allGranted)
              ElevatedButton.icon(
                onPressed: checkPermissions,
                icon: const Icon(Icons.refresh),
                label: const Text("Retry All"),
              ),
            if (allGranted)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
