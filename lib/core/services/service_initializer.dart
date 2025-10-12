import 'package:get_it/get_it.dart';
import 'mesh_network_service.dart';
import 'message_storage_service.dart';
import 'emergency_service.dart';

final getIt = GetIt.instance;

/// Initialize all services
Future<void> initializeServices() async {
  // Register mesh network service
  getIt.registerSingleton<MeshNetworkService>(MeshNetworkService());

  // Register storage service
  final storageService = MessageStorageService();
  await storageService.init();
  getIt.registerSingleton<MessageStorageService>(storageService);

  // Register emergency service
  getIt.registerSingleton<EmergencyService>(EmergencyService());

  // Start mesh network service
  await getIt<MeshNetworkService>().startDiscovery();
}

/// Cleanup all services
Future<void> cleanupServices() async {
  await getIt<MeshNetworkService>().stopDiscovery();
  await getIt<MessageStorageService>().dispose();
  await getIt.reset();
}
