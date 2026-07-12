import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mc_ssp/features/authentication/repositories/auth_repository.dart';

/// Provides a singleton `AuthRepository` for the app.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
