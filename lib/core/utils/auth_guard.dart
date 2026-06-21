import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../presentation/auth/auth_gate_bottom_sheet.dart';

/// Requires authentication before proceeding.
/// Returns true if the user is authenticated (or just authenticated successfully).
/// Returns false if the user dismissed the auth sheet.
Future<bool> requireAuth(BuildContext context) async {
  final authState = context.read<AuthBloc>().state;
  if (authState is AuthAuthenticated) {
    return true;
  }
  
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<AuthBloc>(),
      child: const AuthGateBottomSheet(),
    ),
  );
  
  return result == true;
}
