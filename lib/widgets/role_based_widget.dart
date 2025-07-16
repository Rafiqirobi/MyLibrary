import 'package:flutter/material.dart';
import 'package:my_library/models/user.dart';

class RoleBasedWidget extends StatelessWidget {
  final Widget reader;
  final Widget clerk;
  final Widget manager;
  final AppUser user;

  const RoleBasedWidget({
    required this.reader,
    required this.clerk,
    required this.manager,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    switch (user.role) {
      case 'reader':
        return reader;
      case 'clerk':
        return clerk;
      case 'manager':
        return manager;
      default:
        return reader; // Default to reader view
    }
  }
}