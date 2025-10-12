import 'package:get_it/get_it.dart';
import '../services/mesh_network_service.dart';
import '../services/message_storage_service.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Initialize all services and register with GetIt
Future<void> setupServiceLocator() async {
  // Storage service (singleton)
  getIt.registerLazySingleton<MessageStorageService>(
    () => MessageStorageService(),
  );

  // Initialize storage
  await getIt<MessageStorageService>().initialize();

  // Mesh network service (singleton)
  getIt.registerLazySingleton<MeshNetworkService>(
    () => MeshNetworkService(),
  );

  // TODO: Add more services as needed:
  // - EncryptionService
  // - RoutingService
  // - NotificationService
  // - etc.
}

/// Clean up and dispose all services
Future<void> disposeServices() async {
  await getIt<MessageStorageService>().close();
  getIt<MeshNetworkService>().dispose();
  await getIt.reset();
}
